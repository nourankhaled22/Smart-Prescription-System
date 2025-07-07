import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/medication.dart';

class MedicationService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<List<Medication>> getmedicines(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/medicine/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> medicinesJson = data['data']['medicines'];
        return medicinesJson.map((item) => Medication.fromJson(item)).toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch medicines');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Medication> addmedicine({
    required String token,
    required String medicineName,
    int? frequency,
    String? dosage,
    int? duration,
    bool? afterMeal,
    int? hoursPerDay,
    String? date,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "medicineName": medicineName,
        if (frequency != null) "frequency": frequency,
        if (dosage != null) "dosage": dosage,
        if (duration != null) "duration": duration,
        if (afterMeal != null) "afterMeal": afterMeal,
        if (hoursPerDay != null) "hoursPerDay": hoursPerDay,
        if (date != null && date.isNotEmpty) "date": date,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Medication.fromJson(data['data']['newMedicine']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add medicine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletemedicine(String token, String medicineId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/medicine/$medicineId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete medicine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatemedicine({
    required String token,
    required String medicineId,
    required String medicineName,
    required int frequency,
    required String dosage,
    required int duration,
    required bool afterMeal,
    String? date,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "medicineName": medicineName,
        "frequency": frequency,
        "dosage": dosage,
        "duration": duration,
        "afterMeal": afterMeal,
      };

      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/api/medicine/$medicineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update medicine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateMedcineStatus(
    String token,
    String medicineId,
    bool isActive,
  ) async {
    try {
      final Map<String, dynamic> body = {"isActive": isActive};
      final response = await http.patch(
        Uri.parse('$baseUrl/api/medicine/$medicineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update medicine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> getMedicineInfo(
    String token,
    String medicineName,
    String language,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/medicine/get-medicine-info?name=$medicineName&language=$language',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to retrieve medicine info');
      }
      return jsonDecode(response.body)['data']['response'];
    } catch (e) {
      throw Exception('Failed to retrieve medicine info: $e');
    }
  }

  Future<Medication> scheduleMedicine({
    required String token,
    required String medicineId,
    required int frequency,
    required DateTime startDate,
    required String startTime,
    required int hoursPerDay,
    required int duration,
    String? date,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "frequency": frequency,
        "startDate": startDate.toIso8601String(),
        "startTime": startTime,
        "hoursPerDay": hoursPerDay,
        "duration": duration,
      };

      final response = await http.patch(
        Uri.parse('$baseUrl/api/medicine/$medicineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Medication.fromJson(data['data']['updatedMedicine']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update medicine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Medication> scanMadicine({
    required String token,
    required File file,
  }) async {
    try {
      final dio = Dio();

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'medicine': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        '$baseUrl/api/scan-medicine/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data; // already decoded
      return Medication.fromJson(data['data']['medicine']);
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          e.response?.data['data']?['error'] ??
              e.message ??
              'Failed to add medicine',
        );
      } else {
        throw Exception(e);
      }
    }
  }

  Future<List<dynamic>> searchForMedicines(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/medicine/auto-complete?name=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch medicines');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
