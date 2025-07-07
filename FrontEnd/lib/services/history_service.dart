import 'package:http/http.dart' as http;
import '/models/userModel.dart';
import 'dart:convert';
import '../models/vaccine.dart';

class HistoryService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<UserModel> getPatient(String token, String sessionToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/history/'),
        headers: {
          'Authorization': 'Bearer $token',
          'SessionToken': 'Bearer $sessionToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data['data']['patient']);
      } else {
        final error = json.decode(response.body);

        throw Exception(error['message'] ?? 'Failed to fetch patient ');
      }
    } catch (e) {
      throw Exception('Failed to fetch patient : $e');
    }
  }

  Future<Map<String, dynamic>> getHistory(
    String token,
    String sessionToken,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/history/'),
        headers: {
          'Authorization': 'Bearer $token',
          'SessionToken': 'Bearer $sessionToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data']['history'];
      } else {
        final error = json.decode(response.body);

        throw Exception(error['message'] ?? 'Failed to fetch patient history');
      }
    } catch (e) {
      throw Exception('Failed to fetch patient history: $e');
    }
  }

  Future<Map<String, dynamic>> getHistorySummary(
    String token,
    String language,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/history-summary?language=$language'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('$baseUrl/api/history-summary?language=$language');

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to retrieve medicine info');
      }
      return jsonDecode(response.body)['data']['response'];
    } catch (e) {
      throw Exception('Failed to retrieve medicine info: $e');
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
      throw Exception('Failed to add vaccine: $e');
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
      throw Exception('Failed to delete vaccine: $e');
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
      throw Exception('Failed to update vaccine: $e');
    }
  }
}
