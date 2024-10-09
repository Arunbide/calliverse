import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String username = 'admin'; // Adjusted format
  final String password = 'changeme733678DwxM436jP2jdkdj36jkd'; // Your Matrix password
  final TextEditingController _messageController = TextEditingController();
  final String _roomId = '!gTWTydcZxkDMpmweqV:calliverse.com'; // Replace with your room ID

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Matrix Chat')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final success = await chatProvider.login(username, password);
              if (success) {
                await chatProvider.syncMessages();
              } else {
                // Handle login failure
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login failed. Check your credentials.')),
                );
              }
            },
            child: Text('Login'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatProvider.messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await chatProvider.sendMessage(_roomId, _messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
