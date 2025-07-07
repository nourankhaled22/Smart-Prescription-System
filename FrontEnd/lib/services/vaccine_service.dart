import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/vaccine.dart';

class VaccineService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<List<Vaccine>> getAllergies(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/vaccine/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> vaccinesJson = data['data']['vaccines'];
        return vaccinesJson.map((item) => Vaccine.fromJson(item)).toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch vaccines');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Vaccine> addvaccine(
    String token,
    String vaccineName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'vaccineName': vaccineName};
      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/vaccine/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Vaccine.fromJson(data['data']['newVaccine']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add vaccine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletevaccine(String token, String vaccineId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/vaccine/$vaccineId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete vaccine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatevaccine(
    String token,
    String vaccineId,
    String vaccineName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'vaccineName': vaccineName};

      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/api/vaccine/$vaccineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update vaccine');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
