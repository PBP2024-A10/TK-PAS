import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/homepage.dart';
import 'package:ajengan_halal_mobile/auth/screens/register.dart';
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
      body: Stack(
        children: [
          // Background image section
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/web-logo.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken),
              ),
            ),
          ),
          // Main content area
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Heading Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/web-logo.png', 
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Temukan Kuliner Halal di Bali!',
                        style: GoogleFonts.rasa(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFcbbcb5),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Login Form Section
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username field
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextField(
                          controller: _usernameController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3d200a),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Color(0xFF654a2d)),
                            filled: true,
                            fillColor: Color(0xFFcbbcb5),
                            prefixIcon: Icon(Icons.person, color: Color(0xFF654a2d)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFF654a2d)),
                            ),
                          ),
                        ),
                      ),
                      // Password field
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextField(
                          controller: _passwordController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3d200a),
                          ),
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Color(0xFF654a2d)),
                            filled: true,
                            fillColor: Color(0xFFcbbcb5),
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF654a2d)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Color(0xFF654a2d),
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFF654a2d)),
                            ),
                          ),
                        ),
                      ),
                      // Login button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'Log In',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            // primary: Color(0xFF654a2d),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      // Sign up and guest login links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Color(0xFF654a2d)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: Color(0xFF3d200a),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Log in as a guest? ',
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Color(0xFF654a2d)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle guest login
                            },
                            child: Text(
                              'Log in',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: Color(0xFF3d200a),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Login function to send HTTP request
  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/auth/login/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome, ${data['username']}!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
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
  }
}