import 'package:flutter/material.dart';
import 'matrix_service.dart';

class ChatProvider with ChangeNotifier {
  String? _accessToken;
  List<String> _messages = [];
  final MatrixService _matrixService;

  ChatProvider(this._matrixService);

  List<String> get messages => _messages;

  // Login to the Matrix server
  Future<bool> login(String username, String password) async {
    _accessToken = await _matrixService.login(username, password);
    return _accessToken != null;
  }

  // Sync and fetch messages
  Future<void> syncMessages() async {
    if (_accessToken == null) return;
    final data = await _matrixService.sync(_accessToken!);
    if (data != null && data['rooms'] != null) {
      _messages.clear();
      final joinedRooms = data['rooms']['join'];
      joinedRooms.forEach((roomId, roomData) {
        final roomMessages = roomData['timeline']['events'];
        for (var event in roomMessages) {
          if (event['type'] == 'm.room.message') {
            _messages.add(event['content']['body']);
          }
        }
      });
      notifyListeners();
    }
  }

  // Send a message to a room
  Future<void> sendMessage(String roomId, String message) async {
    if (_accessToken == null) return;
    await _matrixService.sendMessage(_accessToken!, roomId, message);
    await syncMessages();
  }
}
