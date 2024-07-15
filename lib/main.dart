import 'package:flutter/material.dart';
import '/pages/login_page.dart';
import '/pages/register_page.dart';
import '/pages/reset_password_page.dart';
import '/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/reset_password': (context) => ResetPasswordPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
