import 'dart:convert';
import 'package:calliverse/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'UserContacts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  // Function to log out
  Future<void> logout() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // 'token' should be the exact key you used to store it


      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Token not found. Please log in again.'),
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Use GET request for logout
      var url = Uri.parse('http://192.168.0.115:4000/api/user/logout'); // Your logout API endpoint
      var response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token", // Send token in headers
        },
      );

      var responseData = jsonDecode(response.body);
      print('Response: $responseData'); // Log the response for debugging

      if (response.statusCode == 200) {
        // Logout successful, clear token
        await prefs.remove('token');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logout successful!'),
        ));
        // Navigate to login screen after logout
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to log out';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: isLoading ? null : logout, // Call logout when tapped
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Increment',
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>UserContacts()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text('here will come ChatListScreen!'),
      ),
    );
  }
}
