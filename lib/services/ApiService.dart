// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class ApiService {
//   final String baseUrl = "http://196.168.0.155:4000/api/user/update-profile";
//
//   // POST request to create or update user profile
//   Future<void> createProfile(String token, String userId, String fname, String lname, String bio, String website, XFile? image) async {
//     var uri = Uri.parse("$baseUrl/user/update-profile");
//
//     var request = http.MultipartRequest("POST", uri);
//     request.headers['Authorization'] = 'Bearer $token'; // Pass token in headers
//
//     // Add fields
//     request.fields['user_id'] = userId;
//     request.fields['fname'] = fname;
//     request.fields['lname'] = lname;
//     request.fields['bio'] = bio;
//     request.fields['website'] = website;
//
//     // Add image if selected
//     if (image != null) {
//       var file = await http.MultipartFile.fromPath('profile', image.path);
//       request.files.add(file);
//     }
//
//     // Send request
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Profile updated successfully');
//     } else {
//       print('Failed to update profile');
//     }
//   }
//
//   // GET request to fetch user profile data
//   Future<Map<String, dynamic>> getUserProfile(String token, String userId) async {
//     var url = Uri.parse("$baseUrl/user/$userId");
//     var response = await http.get(url, headers: {
//       'Authorization': 'Bearer $token', // Pass token in headers
//     });
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch user profile');
//     }
//   }
// }
