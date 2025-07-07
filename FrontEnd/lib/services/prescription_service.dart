import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/prescription.dart';

class PrescriptionService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app/api/prescription';

  // Get all prescriptions

  Future<List<Prescription>> getPrescriptions(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(response.body)['data']['prescriptions'];
      return jsonList.map((json) => Prescription.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }

  // Get all prescriptions
  Future<List<Map<String, dynamic>>> getDoctorPrescriptions(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
        print(response);


    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(response.body)['data']['prescriptions'];
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }

  // Get a single prescription by ID
  Future<Prescription> getPrescriptionById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Prescription.fromJson(data['prescription']);
    } else {
      throw Exception('Failed to load prescription');
    }
  }

  // Add a new prescription
  Future<Prescription> addPrescription(
    Map<String, dynamic> prescriptionData,
    String token,
    String sessionToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'sessionToken': 'Bearer $sessionToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(prescriptionData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body)['data']['prescription'];
        return Prescription.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add prescription');
      }
    } catch (e) {
      throw Exception('Failed to add prescription: $e');
    }
  }

  // Update an existing prescription
  Future<void> updatePrescription(
    Prescription prescription,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${prescription.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(prescription.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update prescription');
    }
  }

  // Delete a prescription
  Future<void> deletePrescription(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception('Failed to delete prescription : ${error['message']}');
    }
  }

  Future<Prescription> scanPrescription({
    required String token,
    required File file,
  }) async {
    try {
      final dio = Dio();

      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'prescription': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        'https://graduationproject-production-a107.up.railway.app/api/scan-prescription/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data; // already decoded
      return Prescription.fromJson(data['data']['prescription']);
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          e.response?.data['data']?['error'] ??
              e.message ??
              'Failed to add prescription',
        );
      } else {
        throw Exception('Failed to add prescription');
      }
    }
  }
}
