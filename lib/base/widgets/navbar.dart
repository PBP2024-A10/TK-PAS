import 'package:ajengan_halal_mobile/wishlist/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/homepage.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:ajengan_halal_mobile/auth/screens/register.dart';
import 'package:ajengan_halal_mobile/profile/profile.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart' as pbp;
import 'package:provider/provider.dart';


class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil instance CookieRequest
    var request = context.read<pbp.CookieRequest>();
    
    // List tile yang akan selalu ditampilkan
    List<Widget> commonMenuItems = [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Halaman Utama'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Homepage(),
            ),
          );
        },
      ),
    ];

    // List tile khusus untuk user yang sudah login
    List<Widget> loggedInMenuItems = [
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.favorite),
        title: const Text('WishList'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WishlistPage(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () async {
          final response = await http.post(
              Uri.parse("http://127.0.0.1:8000/auth/logout_flutter/"));
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String message = responseData["message"];
          if (context.mounted) {
              if (responseData['status']) {
                  String uname = responseData["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
              } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message),
                      ),
                  );
              }
          }
        },
      ),
    ];

    // List tile untuk login/register jika belum login
    List<Widget> notLoggedInMenuItems = [
      ListTile(
        leading: const Icon(Icons.login),
        title: const Text('Login'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.app_registration),
        title: const Text('Register'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
      ),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/navbar-logo.png',
                  width: 50,
                  height: 50,
                ),
                const Text(
                  "Cari makanan halal di Ajengan Halal!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Menu utama selalu ditampilkan
          ...commonMenuItems,
          
          // Tampilkan menu login/register jika belum login
          if (!(request.jsonData.containsKey('username') && 
                request.jsonData['username'] != null))
            ...notLoggedInMenuItems,
          
          // Tampilkan menu khusus jika sudah login
          if (request.jsonData.containsKey('username') && 
              request.jsonData['username'] != null)
            ...loggedInMenuItems,
        ],
      ),
    );
  }
}