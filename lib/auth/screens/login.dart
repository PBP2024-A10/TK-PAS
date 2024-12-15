import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/homepage.dart';
import 'package:ajengan_halal_mobile/auth/screens/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


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
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView( // Add SingleChildScrollView here
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
                          height: 180,  // Mengurangi tinggi logo agar ada ruang
                        ),
                        const SizedBox(height: 15),  // Mengurangi jarak antara logo dan heading
                        Text(
                          'Temukan Kuliner Halal di Bali!',
                          style: GoogleFonts.rasa(
                            fontSize: 28,  // Mengurangi ukuran font
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
                    margin: const EdgeInsets.all(16.0),  // Mengurangi margin
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Mengurangi padding vertikal
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Mengurangi padding vertikal
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
                          padding: const EdgeInsets.symmetric(vertical: 15.0),  // Mengurangi jarak vertical
                          child: ElevatedButton(
                            onPressed: () => _login(request),
                            child: Text(
                              'Log In',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3d200a),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
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
                               Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Homepage()),
                                );
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
          ),
        ],
      ),
    );
  }

  // Login function to send HTTP request
  void _login(CookieRequest request) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await request
        .login("http://127.0.0.1:8000/auth/login_flutter/", {
      'username': username,
      'password': password,
    });

    if (request.loggedIn) {
      String message = response['message'];
      String uname = response['username'];
      if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Homepage()),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content:
                      Text("$message Selamat datang, $uname.")),
            );
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Gagal'),
              content: Text(response['message']),
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
}