import 'package:http/http.dart' as http;

class AdminServices {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<void> suspendUser(String userId, String token) async {
    try {
      await http.patch(
        Uri.parse(
          '$baseUrl/api/patient/suspend-patient/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Failed to suspend user: $e');
    }
  }
  Future<void> activateUser(String userId, String token) async {
    try {
       await http.patch(
        Uri.parse(
          '$baseUrl/api/patient/activate-patient/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Failed to suspend user: $e');
    }
  }
  Future<void> suspendDoctor(String userId, String token) async {
    try {
      await http.patch(
        Uri.parse(
          '$baseUrl/api/doctor/suspend-doctor/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Failed to suspend doctor: $e');
    }
  }
  Future<void> activateDoctor(String userId, String token) async {
    try {
      await http.patch(
        Uri.parse(
          '$baseUrl/api/doctor/activate-doctor/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Failed to activate doctor: $e');
    }
  }
  Future<void> rejectDoctor(String userId, String token) async {
    try {
      await http.patch(
        Uri.parse(
          '$baseUrl/api/doctor/reject-doctor/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Failed to reject doctor: $e');
    }
  }

 
}
