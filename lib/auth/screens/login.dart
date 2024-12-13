import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ajengan_halal_mobile/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';

void main() {
  runApp(const LoginApp());
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 8.0, right: 8.0, bottom: 8.0),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: Warna.white,
              ),
            ),
          ),
        ),
        backgroundColor: Warna.backgrounddark,  // Coklat Gelap
      ),
      backgroundColor: Warna.backgrounddark,  // Coklat Gelap
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                color: Warna.background, // Coklat Agak Gelap
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: TextField(
                      controller: _usernameController,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Warna.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Warna.lightcyan,  // Coklat Terang
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: Warna.cyan),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Warna.cyan),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Warna.line),
                        ),
                        labelStyle: TextStyle(color: Warna.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: TextField(
                      controller: _passwordController,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Warna.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Warna.lightcyan,  // Coklat Terang
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.lock, color: Warna.cyan),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Warna.cyan),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Warna.line),
                        ),
                        labelStyle: TextStyle(color: Warna.white),
                      ),
                      obscureText: !_passwordVisible,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      // Make sure the request sends correct headers and body
                      final response = await http.post(
                        Uri.parse("http://127.0.0.1:8000/auth/login/"),
                        headers: {"Content-Type": "application/json"},
                        body: json.encode({
                          'username': username,
                          'password': password,
                        }),
                      );

                      if (response.statusCode == 200) {
                        // Check if login is successful based on response
                        final data = json.decode(response.body);

                        if (data['status'] == true) {
                          // Login successful
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Welcome, ${data['username']}!")),
                          );

                          // Navigate to the homepage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        } else {
                          // Show error message from response
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Failed'),
                              content: Text(data['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        // If server response is not 200
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text('Server error: ${response.statusCode}'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: Warna.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(385, 64),
                      backgroundColor: Warna.blue,  // Warna biru tombol
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
