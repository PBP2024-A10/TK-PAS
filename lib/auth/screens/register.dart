import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();  

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Warna.backgroundlight,
        title: const Text('Register', style: TextStyle(fontFamily: 'Roboto', fontSize: 22.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form( // Wrap with Form widget
            key: _formKey,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Register Yourself',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    // Username
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: Warna.backgroundlight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: Warna.backgroundlight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Warna.backgroundlight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        filled: true,
                        fillColor: Warna.backgroundlight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate form before submission
                        if (_formKey.currentState!.validate()) {
                          String username = _usernameController.text;
                          String email = _emailController.text;
                          String password1 = _passwordController.text;
                          String password2 = _confirmPasswordController.text;

                          final response = await request.postJson(
                              "http://127.0.0.1:8000/auth/register_flutter/",
                              jsonEncode({
                                "username": username,
                                "email": email,
                                "password1": password1,
                                "password2": password2,
                              }));
                          
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Successfully registered!'),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            } else {
                              // Show error message from backend
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ?? 'Failed to register!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Warna.backgrounddark,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Register Here'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}