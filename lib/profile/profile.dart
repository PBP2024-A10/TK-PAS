import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart'; 
import 'package:ajengan_halal_mobile/auth/screens/login.dart';

void handleLogout(BuildContext context) async {
  final request = Provider.of<CookieRequest>(context, listen: false);
  final response = await request.logout("http://127.0.0.1:8000/auth/login/");
  String message = response["message"];
  if (response['status']) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$message Sampai jumpa."),
    ));
    // Setelah logout, arahkan ke halaman onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginApp()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Warna.blue, // Set background color
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: Container(
            width: double.infinity,
            color: Warna.background, // Set content background
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Opsi Edit Profile
                  _buildProfileOption("Edit Display Name", "assets/icons/Edit Profile.png", () {
                    // Ganti sesuai dengan halaman yang ada untuk edit user
                    // Navigator.push(
                    //   // context,
                    //   // MaterialPageRoute(builder: (context) => EditProfile()),
                    // );
                  }),
                  // SizedBox(height: 24),
                  // // Opsi Privacy Policy
                  // _buildProfileOption("Privacy Policy", "assets/icons/Privacy Policy.png", () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                  //   );
                  // }),
                  const SizedBox(height: 24),
                  // Opsi Logout
                  _buildProfileOption("Logout", "assets/icons/Logout.png", () {
                    handleLogout(context);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat opsi menu di profil
  Widget _buildProfileOption(String title, String iconPath, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        color: Colors.transparent, // Set background color for each option if needed
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ikon yang muncul di sebelah kiri
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              width: 40,
              height: 40,
              child: Image.asset(iconPath),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Warna.white, // Mengatur warna teks
                ),
              ),
            ),
            // Ikon panah kanan yang mengarah ke halaman baru
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset("assets/icons/Left Arrow.png", fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
