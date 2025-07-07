import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/allergy.dart';

class AllergyService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<List<Allergy>> getAllergies(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/allergy/',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> allergiesJson = data['data']['allergies'];
        return allergiesJson.map((item) => Allergy.fromJson(item)).toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch allergies');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Allergy> addAllergy(
    String token,
    String allergyName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'allergyName': allergyName};
      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/allergy/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Allergy.fromJson(data['data']['newAllergy']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add allergy');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteAllergy(String token, String allergyId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/allergy/$allergyId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete allergy');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateAllergy(
    String token,
    String allergyId,
    String allergyName,
    String? date,
  ) async {
    try {
      final Map<String, dynamic> body = {'allergyName': allergyName};

      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final response = await http.patch(
        Uri.parse(
          '$baseUrl/api/allergy/$allergyId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update allergy');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
