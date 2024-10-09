// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   final String token; // Pass the user token for authentication
//
//   ProfileScreen({required this.userId, required this.token});
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? firstName;
//   String? lastName;
//   String? bio;
//   String? website;
//   File? profileImage;
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _chooseProfileImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _submitProfile() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       try {
//         var response = await _uploadProfileData(
//           widget.userId,
//           firstName!,
//           lastName!,
//           bio ?? "",
//           website ?? "",
//           profileImage,
//           widget.token,
//         );
//
//         if (response.statusCode == 200) {
//           print('Profile updated successfully');
//         } else {
//           print('Failed to update profile');
//           print('Response status: ${response.statusCode}');
//           print('Response body: ${response.body}');
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   firstName = value;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Last Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   lastName = value;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Bio'),
//                 onSaved: (value) {
//                   bio = value;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Website'),
//                 onSaved: (value) {
//                   website = value;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _chooseProfileImage,
//                 child: Text('Choose Profile Image'),
//               ),
//               profileImage != null
//                   ? Image.file(profileImage!, height: 100, width: 100)
//                   : Container(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitProfile,
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future<http.Response> _uploadProfileData(
//       String userId,
//       String firstName,
//       String lastName,
//       String bio,
//       String website,
//       File? imageFile,
//       String token,
//       ) async {
//     var uri = Uri.parse('http://192.168.0.115:4000/api/user/update-profile');
//     var request = http.MultipartRequest('POST', uri);
//
//     request.fields['fname'] = firstName;
//     request.fields['lname'] = lastName;
//     request.fields['bio'] = bio;
//     request.fields['website'] = website;
//     request.fields['user_id'] = userId;
//
//     if (imageFile != null) {
//       request.files.add(await http.MultipartFile.fromPath('profile', imageFile.path));
//     }
//
//     request.headers['Authorization'] = 'Bearer $token'; // Add token for authorization if needed
//     request.headers['Content-Type'] = 'multipart/form-data';
//
//     var response = await request.send();
//     return await http.Response.fromStream(response);
//   }
// }
