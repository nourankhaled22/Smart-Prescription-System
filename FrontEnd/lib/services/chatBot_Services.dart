import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotService {
  final String baseUrl =
      'https://graduationproject-production-a107.up.railway.app';

  Future<String> pushMessage(String token, String message) async {
    try {
      final Map<String, dynamic> body = {'message': message};

      final response = await http.post(
        Uri.parse('$baseUrl/api/chatbot'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data']['response'];
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to Send Message');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> deleteChat(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/chatbot'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete Chat');
      }
    } catch (e) {
      throw Exception('Failed to delete chat $e');
    }
  }
}
