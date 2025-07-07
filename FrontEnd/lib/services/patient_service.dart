import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/userModel.dart'; 
class PatientService {
    final String baseUrl ='https://graduationproject-production-a107.up.railway.app';
  Future<List<UserModel>> getAllPatients(String token) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/patient',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List patientsJson = data['data']['patients'];
      return patientsJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch patients');
    }
  }

  Future<UserModel> getPatient(String token, String patientId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/patient/$patientId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['patient']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch patient');
    }
  }

  Future<UserModel> activateUser(String token, String userId) async {
    final response = await http.patch(
      Uri.parse(
        '$baseUrl/api/patient/activate-patient/$userId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['patient']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to activate user');
    }
  }
  Future<UserModel> suspendUser(String token, String userId) async {
    final response = await http.patch(
      Uri.parse(
        '$baseUrl/api/patient/suspend-patient/$userId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['patient']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to activate user');
    }
  }
}
