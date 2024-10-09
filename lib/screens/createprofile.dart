// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// class CreateProfileScreen extends StatefulWidget {
//   final String userId; // Add user ID
//
//   CreateProfileScreen({required this.userId}); // Constructor for passing userId
//
//   @override
//   _CreateProfileScreenState createState() => _CreateProfileScreenState();
// }
//
// class _CreateProfileScreenState extends State<CreateProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   File? _image;
//   final picker = ImagePicker();
//
//   // Controllers for text fields
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   final TextEditingController _websiteController = TextEditingController();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final fname = _firstNameController.text;
//       final lname = _lastNameController.text;
//       final bio = _bioController.text;
//       final website = _websiteController.text;
//       final userId = widget.userId; // Retrieve userId
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://192.168.0.115:4000/api/user/update-profile'), // Update this URL
//       );
//
//       // Add fields to the request
//       request.fields['fname'] = fname;
//       request.fields['lname'] = lname;
//       request.fields['bio'] = bio;
//       request.fields['website'] = website;
//       request.fields['user_id'] = userId; // Use user_id here
//
//       // Add profile image if it exists
//       if (_image != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath('profileImage', _image!.path),
//         );
//       }
//
//       try {
//         var response = await request.send();
//
//         // Check the response
//         if (response.statusCode == 200) {
//           print('Profile updated successfully');
//           // You might want to show a success message or navigate away
//         } else {
//           final responseBody = await response.stream.bytesToString();
//           print('Failed to update profile: ${response.statusCode} - $responseBody');
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
//       appBar: AppBar(title: Text('Update Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundImage: _image != null ? FileImage(_image!) : null,
//                     child: _image == null
//                         ? Icon(Icons.add_a_photo, size: 60)
//                         : null,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: InputDecoration(labelText: 'First Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your first name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: InputDecoration(labelText: 'Last Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your last name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _bioController,
//                   decoration: InputDecoration(labelText: 'Bio (Optional)'),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _websiteController,
//                   decoration: InputDecoration(labelText: 'Website (Optional)'),
//                   keyboardType: TextInputType.url,
//                 ),
//                 SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('Update Profile'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:calliverse/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For File class
import 'package:image_picker/image_picker.dart'; // For picking image from gallery

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String token; // Add auth token

  ProfileScreen({required this.userId, required this.token});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  File? _profileImage; // To hold profile image

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String bio = _bioController.text;
    String website = _websiteController.text;

    var url = Uri.parse('https://yourapiurl.com/user/update-profile');
    var request = http.MultipartRequest('POST', url);

    // Add form fields
    request.fields['fname'] = firstName;
    request.fields['lname'] = lastName;
    request.fields['bio'] = bio;
    request.fields['website'] = website;
    request.fields['user_id'] = widget.userId; // Use the dynamic user ID

    // Add authorization header with the token
    request.headers['Authorization'] = 'Bearer ${widget.token}'; // Include token here

    // Add the profile image if selected
    if (_profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile', _profileImage!.path),
      );
    }

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print("Profile updated successfully");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile updated successfully!"),
        ));
      } else {
        print("Failed to update profile. Status code: ${response.statusCode}");
        print("Response body: ${responseBody.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to update profile."),
        ));
      }
    } catch (error) {
      print("Error occurred: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred while updating profile."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null ? Icon(Icons.person, size: 50, color: Colors.black) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage, // Pick image from gallery
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio (Optional)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Website Link (Optional)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // primary: Colors.blue, // Background color
                ),
              ),
            ), SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    // MaterialPageRoute(builder: (context) =>CreateProfileScreen(userId: widget.userID,)),
                    MaterialPageRoute(builder: (context) =>HomePage()),
                  );
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // primary: Colors.blue, // Background color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(userId: 'your_user_id_here', token: 'your_auth_token_here'),
  ));
}
