import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/examination.dart';
import 'dart:typed_data';

class ExaminationService {
   final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';
  Future<List<Examination>> getExaminations(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/examination/',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> examinationsJson = data['data']['examinations'];
        return examinationsJson
            .map((item) => Examination.fromJson(item))
            .toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch examinations');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Examination> addExamination({
    required String token,
    required String examinationName,
    required DateTime date,
    required File file,
  }) async {
    try {
      final dio = Dio();

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'examinationName': examinationName,
        'date': date.toIso8601String(),
        'examination': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '$baseUrl/api/examination/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        return Examination.fromJson(data['data']['newExamination']);
      } else {
        final error = response.data;
        throw Exception(error['message'] ?? 'Failed to add examination');
      }
    } catch (e) {
      throw Exception('Failed to add examination: $e');
    }
  }

  Future<void> deleteexamination(String token, String examinationId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/examination/$examinationId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete examination');
      }
    } catch (e) {
      throw Exception('Failed to delete examination: $e');
    }
  }

  Future<Examination> updateExaminationJson({
    required String token,
    required String examinationId,
    required String examinationName,
    required DateTime date,
    String? notes, // Add other fields as needed
  }) async {
    try {
      final dio = Dio();

      final Map<String, dynamic> data = {
        'examinationName': examinationName,
        'date': date.toIso8601String(),
        if (notes != null) 'notes': notes,
      };

      final response = await dio.patch(
        '$baseUrl/api/examination/$examinationId',
        data: data,
        options: Options(
          method: 'PATCH',
          responseType: ResponseType.json,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        return Examination.fromJson(
          response.data['data']['updatedExamination'],
        );
      } else {
        throw Exception('Failed to update examination');
      }
    } catch (e) {
      throw Exception('Failed to update examination: $e');
    }
  }

  Future<void> requestDownloadPermissions() async {
    // 1. Request storage permission (for Android < 13)
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        throw Exception('Storage permission not granted');
      }

      // 2. For Android 13+ (API 33+), request media permissions if needed
      if (await Permission.manageExternalStorage.isDenied) {
        var manageStatus = await Permission.manageExternalStorage.request();
        if (!manageStatus.isGranted) {
          throw Exception('Manage external storage permission not granted');
        }
      }
      await Permission.mediaLibrary.request();
    }
  }

  Future<String?> downloadExaminationPdf({
    required String token,
    required String examinationId,
    required String fileName,
    String? sessionToken,
  }) async {
    try {
      await requestDownloadPermissions();
      final dio = Dio();
      final response = await dio.get(
        '$baseUrl/api/examination/$examinationId',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $token',
            if (sessionToken != null) 'sessionToken': ' Bearer $sessionToken',
          },
        ),
      );

      Uint8List bytes = Uint8List.fromList(response.data);
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      final filePath = '${downloadsDir!.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      throw Exception('Failed to download PDF: $e');
    }
  }
}
