
import 'dart:convert';

import 'package:calliverse/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'email_otp_verification.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> signup() async {
    String email = emailController.text;
    String password = passwordController.text;
    String repassword = rePasswordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email is required'),
      ));
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password is required'),
      ));
      return;
    }

    if (repassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Confirm Password is required'),
      ));
      return;
    }

    if (password != repassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('http://192.168.0.115:4000/api/user/create');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirm_password': repassword, // Include this if the server requires it
        }),
      );

      setState(() {
        isLoading = false;
      });

      // Check for both 200 and 201 status codes for success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final responseData = jsonDecode(response.body);
        String userId = responseData['data']['_id']; // Assuming the backend returns user_id
        // String token = responseData['data']['token']; // Assuming backend returns token
        //
        // // Store the token in SharedPreferences
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', token); // Store token

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP Sent to $email '),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              email: email,
              userID: userId, // Pass the correct userID here
            ),
          ),
        );
      } else if (response.statusCode == 400) { // Handle 400 error
        var errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Opss... ${errorResponse['message']}'),
        ));
      } else if (response.statusCode == 401) { // Handle 401 error
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

      print("Error: $e");  // Print the error for debugging
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
          padding: const EdgeInsets.only(top: 150,left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              // Image.asset(
              //   // 'assets/images/logo.png', // Replace with your logo asset
              //   'assets/images/logo_white.png', // Replace with your logo asset
              //   height: 100, // Adjust height as needed
              // ),
              SizedBox(height: 24.0),

              // Welcome text
              Text(
                'Sign Up with Email',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),

              // Login instruction
              Text(
                'Please create your account using your email.',
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

              // Password input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              TextField(
                controller: rePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Conform Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 32.0),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child:  ElevatedButton(
                  onPressed: isLoading ? null : signup,
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




