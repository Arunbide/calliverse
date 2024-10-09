import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_pass_VerifyOtpScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> forgot_pass_send_otp() async {
    String email = emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email is required'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    // var url = Uri.parse("http://192.168.209.65:4000/api/user/forgot-password");
    var url = Uri.parse("http://192.168.0.115:4000/api/user/forgot-password");

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);

        final responseData = jsonDecode(response.body);
        String userId = responseData['data']['_id'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP Sended to $email '),
        ));

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => forgot_pass_verifiy_otp_screen(
                  email: email,
                  userID: userId,
                )));
      } else if (response.statusCode == 400) {
        var errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Opss... ${errorResponse['message']}'),
        ));
      } else if (response.statusCode == 401) {
        // Handle 400 error
        var errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User Already Exist'),
        ));
      } else {
        // Handle unexpected errors
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup failed: Unexpected error occurred'),
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("Error: $e"); // Print the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Could not connect to server'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter the mail for verification',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 32.0),

              // Email or phone input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email or phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child:  ElevatedButton(
                  onPressed: isLoading ? null : forgot_pass_send_otp,
                  child: isLoading
                      ? CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Continue',
                    style: TextStyle(fontSize: 18.0,color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    // primary: Color(0xFF005EFF), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

