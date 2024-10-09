import 'dart:convert';
import 'package:http/http.dart' as http;

class MatrixService {
  final String homeserverUrl;

  MatrixService() : homeserverUrl = 'https://matrix.calliverse.com'; // Your Matrix server

  // Login to Matrix server
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$homeserverUrl/_matrix/client/r0/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': 'm.login.password',
        'user': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['access_token'];
    } else {
      print('Failed to login: ${response.body}');
      return null;
    }
  }

  // Sync rooms and messages
  Future<Map<String, dynamic>?> sync(String accessToken) async {
    final url = Uri.parse('$homeserverUrl/_matrix/client/r0/sync?access_token=$accessToken');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to sync: ${response.body}');
      return null;
    }
  }

  // Send a message to a room
  Future<void> sendMessage(String accessToken, String roomId, String message) async {
    final url = Uri.parse('$homeserverUrl/_matrix/client/r0/rooms/$roomId/send/m.room.message?access_token=$accessToken');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'msgtype': 'm.text',
        'body': message,
      }),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
