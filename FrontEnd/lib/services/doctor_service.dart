import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/userModel.dart'; // Adjust the import path to your UserModel

class DoctorService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';
  Future<List<UserModel>> getAllUnverfiedDoctors(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/doctor/get-all-unverified-doctors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List patientsJson = data['data']['doctors'];
      return patientsJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch Doctors');
    }
  }

  Future<List<UserModel>> getAllDoctors(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/doctor/get-all-acive-and-suspended-doctors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List patientsJson = data['data']['doctors'];
      return patientsJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch Doctors');
    }
  }

  Future<List<UserModel>> getAllActiveDoctors(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/doctor/get-all-acive-doctors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List patientsJson = data['data']['doctors'];
      return patientsJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch Doctors');
    }
  }

  Future<UserModel> getDoctor(String token, String doctorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/doctor/$doctorId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['doctor']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch Doctor');
    }
  }

  Future<UserModel> activateDoctor(String token, String doctorId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/doctor/activate-doctor/$doctorId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['doctor']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to activate user');
    }
  }

  Future<UserModel> suspendDoctor(String token, String doctorId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/doctor/suspend-doctor/$doctorId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['doctor']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to suspend doctor');
    }
  }

  Future<void> rejectDoctor(String token, String doctorId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/doctor/reject-doctor/$doctorId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to suspend doctor');
    }
  }

  Future<Uint8List?> fetchDoctorLicensePdf({
    required String token,
    required String doctorId,
  }) async {
    final url = Uri.parse('$baseUrl/api/doctor/view-licence/$doctorId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
