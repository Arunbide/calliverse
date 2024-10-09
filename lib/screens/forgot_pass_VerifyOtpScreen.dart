// import 'dart:convert';
//
// import 'package:calliverse/screens/HomeScreen.dart';
// import 'package:calliverse/screens/resetPasswordScreen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class forgot_pass_verifiy_otp_screen extends StatefulWidget {
//
//   final String email;
//   final String userID; // Accept userID dynamically
//
//   forgot_pass_verifiy_otp_screen({required this.email,
//     required this.userID
//   });
//
//
//
//   @override
//   State<forgot_pass_verifiy_otp_screen> createState() => _forgot_pass_verifiy_otp_screenState();
// }
//
// class _forgot_pass_verifiy_otp_screenState extends State<forgot_pass_verifiy_otp_screen> {
//   List<String> otp = ["", "", "", ""]; // Store each OTP character separately
//   final TextEditingController otpController1 = TextEditingController();
//   final TextEditingController otpController2 = TextEditingController();
//   final TextEditingController otpController3 = TextEditingController();
//   final TextEditingController otpController4 = TextEditingController();
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 40),
//                   // Image.asset('assets/images/logo_white.png'), // Add your logo here
//                   SizedBox(height: 20),
//                   Text(
//                     "Enter Code",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "We have sent you an Email with the Forgot Password code to ${widget.email}",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _otpTextField(otpController1, 0),
//                       _otpTextField(otpController2, 1),
//                       _otpTextField(otpController3, 2),
//                       _otpTextField(otpController4, 3),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () {
//                       // Resend OTP API logic here
//                     },
//                     child: Text("Resend Code"),
//                   ),
//                   SizedBox(height: 40),
//                 ],
//               ),
//             ),
//             if (isLoading)
//               Center(child: CircularProgressIndicator()), // Show loading indicator during API call
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _otpTextField(TextEditingController controller, int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: SizedBox(
//         width: 40,
//         child: TextField(
//           controller: controller,
//           autofocus: index == 0,
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           keyboardType: TextInputType.number,
//           maxLength: 1,
//           onChanged: (value) {
//             if (value.isNotEmpty) {
//               otp[index] = value; // Update the correct position in the OTP list
//
//               if (index < 3) {
//                 FocusScope.of(context).nextFocus(); // Focus on next field
//               } else {
//                 FocusScope.of(context).unfocus(); // Remove focus from last field
//               }
//             }
//             setState(() {});
//             // Automatically trigger verification when all fields are filled
//             if (otp.join().length == 4) {
//               _verifyOTP();
//             }
//           },
//           decoration: InputDecoration(
//             counterText: "",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _verifyOTP() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // final url = Uri.parse('http://your-api-url.com/api/verify-otp'); // Replace with your API URL
//     final url = Uri.parse('http://192.168.0.108:4000/api/user/verify-otp?type=forgot-password'); // Replace with your API URL
//     // final url = Uri.parse('http://192.168.209.65:4000/api/user/verify-otp?type=forgot-password'); // Replace with your API URL
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           // Add any other necessary headers here, such as authorization if needed
//         },
//         body: jsonEncode({
//           // 'user_id': "66f2a9804eb461f2b3a21092", // Replace with actual user_id from your backend
//           'user_id': widget.userID, // Replace with actual user_id from your backend
//           'otp': otp.join(), // Send the complete OTP string to the backend
//         }),
//       );
//
//       setState(() {
//         isLoading = false;
//       });
//
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         String token = responseData['data']['token'];  // Extract the token
//
//         // Store the token in SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//
//
//
//         if (responseData['status'] == 'success') {
//           // Navigate to HomeScreen if OTP is correct
//           Navigator.of(context).pushReplacement(
//             // MaterialPageRoute(builder: (context) => ResetPasswordScreen(userId: widget.userID,)),
//             MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
//           );
//           String token = responseData['data']['token'];  // Extract the token
//
//           // Store the token in SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//         } else {
//           // Show error if OTP is incorrect
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('OTP does not match. Please try again.'),
//           ));
//         }
//       } else if (response.statusCode == 401) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Unauthorized: Invalid OTP or user_id.'),
//         ));
//       } else {
//         // Handle other status codes (e.g., 400, 500)
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to verify OTP. Please try again later.'),
//         ));
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error: $error");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: Could not connect to server'),
//       ));
//     }
//   }
// }
//
// //


import 'dart:convert';

import 'package:calliverse/screens/resetPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class forgot_pass_verifiy_otp_screen extends StatefulWidget {
  final String email;
  final String userID; // Accept userID dynamically

  forgot_pass_verifiy_otp_screen({
    required this.email,
    required this.userID,
  });

  @override
  State<forgot_pass_verifiy_otp_screen> createState() =>
      _forgot_pass_verifiy_otp_screenState();
}

class _forgot_pass_verifiy_otp_screenState
    extends State<forgot_pass_verifiy_otp_screen> {
  List<String> otp = ["", "", "", ""]; // Store each OTP character separately
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  bool isLoading = false;
  bool isResending = false; // State for resend OTP button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  // Image.asset('assets/images/logo_white.png'), // Add your logo here
                  SizedBox(height: 20),
                  Text(
                    "Enter Code",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We have sent you an Email with the Forgot Password code to ${widget.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _otpTextField(otpController1, 0),
                      _otpTextField(otpController2, 1),
                      _otpTextField(otpController3, 2),
                      _otpTextField(otpController4, 3),
                    ],
                  ),
                  SizedBox(height: 20),
                  isResending
                      ? CircularProgressIndicator() // Show loading when resending OTP
                      : TextButton(
                    onPressed: () {
                      resendOTP(); // Call resend OTP function
                    },
                    child: Text("Resend Code"),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            if (isLoading)
              Center(child: CircularProgressIndicator()), // Show loading indicator during API call
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 40,
        child: TextField(
          controller: controller,
          autofocus: index == 0,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: (value) {
            if (value.isNotEmpty) {
              otp[index] = value; // Update the correct position in the OTP list

              if (index < 3) {
                FocusScope.of(context).nextFocus(); // Focus on next field
              } else {
                FocusScope.of(context).unfocus(); // Remove focus from last field
              }
            }
            setState(() {});
            // Automatically trigger verification when all fields are filled
            if (otp.join().length == 4) {
              _verifyOTP();
            }
          },
          decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  // Function to verify the OTP
  Future<void> _verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.0.115:4000/api/user/verify-otp?type=forgot-password'); // Replace with your API URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': widget.userID,
          'otp': otp.join(), // Send the complete OTP string to the backend
        }),
      );

      setState(() {
        isLoading = false;
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['data']['token']; // Extract the token

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        if (responseData['status'] == 'success') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => ResetPasswordScreen()), // Navigate to Reset Password screen
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('OTP does not match. Please try again.'),
          ));
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unauthorized: Invalid OTP or user_id.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to verify OTP. Please try again later.'),
        ));
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Could not connect to server'),
      ));
    }
  }

  // Function to resend OTP
  Future<void> resendOTP() async {
    setState(() {
      isResending = true; // Show loader for resend action
    });

    final url = Uri.parse('http://192.168.0.108:4000/api/user/resend-otp/${widget.userID}'); // API endpoint for resending OTP

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        isResending = false; // Hide loader
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('OTP has been resent successfully.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to resend OTP.'),
        ));
      }
    } catch (error) {
      setState(() {
        isResending = false; // Hide loader in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Could not connect to server'),
      ));
    }
  }
}
