import 'dart:convert';
import 'package:calliverse/screens/HomeScreen.dart';
import 'package:calliverse/screens/RegisterScreen.dart';
import 'package:calliverse/screens/forgot_password.dart';
import 'package:calliverse/screens/profileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in both fields'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('http://192.168.0.115:4000/api/user/login');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // Parse the response body
        var responseData = jsonDecode(response.body);
        String token = responseData['data']['token'];  // Extract the token

        // Store the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successful'),
        ));

        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        var errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: ${errorResponse['message']}'),
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

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
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo_white.png', // Replace with your logo asset
              ),
              SizedBox(height: 24.0),

              // Welcome text
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),

              // Login instruction
              Text(
                'Login to continue',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 32.0),

              // Email input
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
              SizedBox(height: 5.0),

              // Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()));
                    },
                    child: Text("Forgot Password ?"),
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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




//








// import 'dart:convert';
// import 'package:calliverse/screens/HomeScreen.dart';
// import 'package:calliverse/screens/forgot_password.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//
//   // Function to login and store the token
//   Future<void> login() async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please fill in both fields'),
//       ));
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     var url = Uri.parse('http://192.168.0.108:4000/api/user/login'); // Replace with your server URL
//
//     try {
//       var response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'}, // Add this header
//         body: jsonEncode({'email': email, 'password': password}),
//       );
//
//       setState(() {
//         isLoading = false;
//       });
//
//       if (response.statusCode == 200) {
//         // Handle successful login
//         var responseData = jsonDecode(response.body);
//         String token = responseData['token']; // Assuming your token is in the 'token' field of the response
//
//         // Save token using SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token); // Store token for future use
//
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Login successful'),
//         ));
//
//         // Navigate to the home screen
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homescreentest()));
//
//       } else {
//         var errorResponse = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Login failed: ${errorResponse['message']}'),
//         ));
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: Could not connect to server'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: Colors.white,),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 15, right: 15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo
//               Image.asset(
//                 'assets/images/logo_white.png', // Replace with your logo asset
//               ),
//
//               // Welcome text
//               Text(
//                 'Welcome Back!',
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//
//               // Login instruction
//               Text(
//                 'Login to continue',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               SizedBox(height: 32.0),
//
//               // Email or phone input
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter your email or phone',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//
//               // Password input
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(onPressed: () {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
//                   }, child: Text("Forgot Password ?")),
//                 ],
//               ),
//               SizedBox(height: 10.0),
//
//               // Login button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : login,
//                   child: isLoading
//                       ? CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   )
//                       : Text(
//                     'Login',
//                     style: TextStyle(fontSize: 18.0, color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
