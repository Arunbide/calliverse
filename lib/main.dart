// lib/main.dart
import 'package:calliverse/screens/HomeScreen.dart';
import 'package:calliverse/screens/LoginPage.dart';
import 'package:calliverse/screens/RegisterScreen.dart';
import 'package:calliverse/screens/Walkthrough.dart';
import 'package:flutter/material.dart';
// import 'screens/register_screen.dart';
// import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginPage(), // Set initial screen
      home: walkthrough(),
      // initialRoute: '/login',
      // routes: {
      //   '/login': (context) => LoginPage(),
      //   '/home': (context) => HomePage(),
    // }
    );
  }
}







// ================= for metrix server =====================================
// import 'package:calliverse/testing_chat/chat_provider.dart';
// import 'package:calliverse/testing_chat/chat_screen.dart';
// import 'package:calliverse/testing_chat/matrix_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => ChatProvider(MatrixService()),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Matrix Chat App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: ChatScreen(),
//       ),
//     );
//   }
// }
