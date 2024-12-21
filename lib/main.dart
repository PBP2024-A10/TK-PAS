import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';


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
        scaffoldBackgroundColor: Warna.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Warna.backgroundlight,
          secondary: Warna.backgrounddark,
        ),
      ),
      home: const LoginPage(),
    );
  }
}