import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Add this import for CookieRequest
import 'package:ajengan_halal_mobile/auth/screens/login.dart'; // Your login page
import 'package:ajengan_halal_mobile/auth/screens/register.dart'; // Your register page

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Add the CookieRequest provider here
        Provider<CookieRequest>(create: (_) => CookieRequest()),
      ],
      child: const LoginApp(),
    ),
  );
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Your LoginPage is the starting page
    );
  }
}