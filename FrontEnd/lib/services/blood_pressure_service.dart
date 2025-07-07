import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/blood_pressure.dart';

class BloodPressureService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<List<BloodPressure>> getbloodPressures(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/blood-pressure/',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> bloodPressuresJson = data['data']['bloodPressures'];

        return bloodPressuresJson
            .map((item) => BloodPressure.fromJson(item))
            .toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch blood pressures ');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<BloodPressure> addbloodPressure(
    String token,
    final int pulse,
    final int diastolic,
    final int systolic,
    final DateTime date,
  ) async {
    try {
      final Map<String, dynamic> body = {
        'pulse': pulse,
        'diastolic': diastolic,
        'systolic': systolic,
        'date': date.toIso8601String(),
      };

      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/blood-pressure/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BloodPressure.fromJson(data['data']['newBloodPressure']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add blood pressure');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletebloodPressure(String token, String bloodPressureId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/blood-pressure/$bloodPressureId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete blood pressure');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<BloodPressure> updatebloodPressure(
    String token,
    String bloodPressureId,
    final int pulse,
    final int diastolic,
    final int systolic,
    final DateTime date,
  ) async {
    try {
      final Map<String, dynamic> body = {
        'pulse': pulse,
        'diastolic': diastolic,
        'systolic': systolic,
        'date': date.toIso8601String(),
      };
      final response = await http.patch(
        Uri.parse(
          '$baseUrl/api/blood-pressure/$bloodPressureId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BloodPressure.fromJson(data['data']['updatedBloodPressure']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update bloodPressure');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
