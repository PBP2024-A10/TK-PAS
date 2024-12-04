import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/homepage.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:ajengan_halal_mobile/auth/screens/register.dart';
import 'package:ajengan_halal_mobile/profile/profile.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';


class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Ajengan Halal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Beli barang kebutuhanmu di FreshnBloom",
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
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Profile'),
            // Bagian redirection ke MoodEntryFormPage
            onTap: () {
              Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSection(),
                          ));
            },
          ),
        ],
      ),
    );
  }
}