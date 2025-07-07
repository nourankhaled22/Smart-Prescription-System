import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/userModel.dart';

class AuthService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';
  Future<UserModel> login(String phoneNumber, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['data']['user']);
      } else {
        final error = json.decode(response.body);
        throw error['message'] ?? 'Login failed';
      }
    } catch (e) {
      if (e is String) {
        rethrow;
      } else if (e is Exception) {
        throw e.toString().replaceFirst('Exception: ', '');
      } else {
        throw 'Login failed';
      }
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String password,
    String nationalId,
    String dateOfBirth,
    String? address,
  ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/patient-register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'password': password,
        'nationalId': nationalId,
        'dateOfBirth': dateOfBirth,
        'address': address ?? '',
      }),
    );
    if (response.statusCode != 201) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'register failed');
    }
  }

  Future<void> registerDoctor({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String password,
    required String dateOfBirth,
    required String clinicAddress,
    required String specialization,
    File? licence,
  }) async {
    final dio = Dio();
    FormData formData = FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'clinicAddress': clinicAddress,
      'specialization': specialization,
      if (licence != null)
        'licence': await MultipartFile.fromFile(
          licence.path,
          filename: licence.path.split('/').last,
        ),
    });

    final response = await dio.post(
      '$baseUrl/api/auth/doctor-register',
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
        validateStatus: (status) => true,
      ),
    );

    if (response.statusCode != 201) {
      final error = response.data;
      throw Exception(error['message'] ?? 'Doctor registration failed');
    }
  }

  Future<UserModel> getPatientData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/patient/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch patient data');
    }
  }

  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber, 'enteredOtp': otp}),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'OTP verification failed');
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber}),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to send OTP');
    }
  }

  Future<void> forgotPassword(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/forget-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber}),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to send OTP');
    }
  }

  Future<void> verifyOtpForFogettingPassword(
    String phoneNumber,
    String otp,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/api/auth/verify-otp-for-forget-password/$phoneNumber',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'enteredOtp': otp}),
    );
    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'OTP verification failed');
    }
  }

  Future<void> resetPassword(String phoneNumber, String newPassword) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/reset-for-forget-password/$phoneNumber'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'newPassword': newPassword}),
    );
    if (response.statusCode != 201) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to reset password');
    }
  }

  Future<UserModel> getProfile(String token, String role) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch profile');
    }
  }

  Future<UserModel> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationalId,
    required String dateOfBirth,
    String? address,
    required String role,
    String? clinicAddress,
    String? specialization,
  }) async {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'clinicAddress': clinicAddress,
      'specialization': specialization,
    };

    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData['data']['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to update profile');
    }
  }

  Future<bool> isValidToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/is-valid-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 201) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to change password');
    }
  }
}
