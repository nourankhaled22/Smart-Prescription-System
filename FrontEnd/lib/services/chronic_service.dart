import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chronic.dart';

class ChronicService {
  final String baseUrl ='https://graduationproject-production-a107.up.railway.app';

  Future<List<Chronic>> getChronics(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/chronic-disease/',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> chronicsJson = data['data']['chronicDiseases'];
        return chronicsJson.map((item) => Chronic.fromJson(item)).toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch chronic diseases');
      }
    } catch (e) {
      throw Exception('Failed to fetch allergies: $e');
    }
  }

  Future<Chronic> addchronic(
    String token,
    String chronicName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'diseaseName': chronicName};
      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/chronic-disease/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Chronic.fromJson(data['data']['newChronicDisease']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add chronic');
      }
    } catch (e) {
      throw Exception('Failed to add chronic: $e');
    }
  }

  Future<void> deletechronic(String token, String chronicId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/chronic-disease/$chronicId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete chronic');
      }
    } catch (e) {
      throw Exception('Failed to delete chronic: $e');
    }
  }

  Future<void> updatechronic(
    String token,
    String chronicId,
    String chronicName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'diseaseName': chronicName};

      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.patch(
        Uri.parse(
          '$baseUrl/api/chronic-disease/$chronicId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update chronic');
      }
    } catch (e) {
      throw Exception('Failed to update chronic: $e');
    }
  }
}
