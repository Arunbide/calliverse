import 'package:calliverse/screens/LoginPage.dart';
import 'package:calliverse/screens/profileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'RegisterScreen.dart';

class walkthrough extends StatefulWidget {
  const walkthrough({super.key});

  @override
  State<walkthrough> createState() => _walkthroughState();
}

class _walkthroughState extends State<walkthrough> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for the illustration
            Center(
              child: Lottie.asset(
                'assets/animation/verify.json', // Replace with your actual image asset or link
                // height: 150,
              ),
            ),
            SizedBox(height: 50),
            // Text "Connect easily with your family and friends over countries"
            Text(
              'Connect easily with your family and friends over countries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 75),
            // Terms & Privacy Policy
            GestureDetector(
              onTap: () {
                print("terms and condition");
                // Navigate to Terms & Privacy policy page
              },
              child: Text(
                'Terms & Privacy Policy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 15),
            // Button: Continue with email
            ElevatedButton(
              onPressed: () {
                print("Continue with email");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup()));

                // Add logic for email continuation
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Continue with email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 15),
            // Button: Continue with phone
            ElevatedButton(
              onPressed: () {
                print("Continue with phone");
                // Add logic for phone continuation
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                backgroundColor: Colors.black, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Continue with phone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Login link
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));

                // Add logic for login
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                  // decoration: TextDecoration.,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



