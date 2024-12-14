import 'package:cards_makanan/cards_makanan/screens/cards_makanan.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/list_pesanan.dart';
import 'package:flutter/material.dart';
//import 'package:cards_makanan/manajemen_pesanan/screens/menu.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/buat_pesanan_form.dart';

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
                  "Ayo kenyangkan perutmu!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CardsMakanan(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Pesanan'),
            onTap: () {
              // Routing ke halaman BuatPesananForm
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuatPesananForm(),
                ),
              );
            },
          ),
          ListTile(
              leading: const Icon(Icons.add_reaction_rounded),
              title: const Text('Daftar Pesanan'),
              onTap: () {
                  // Route menu ke halaman pesanan
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListPesananPage()),
                  );
              },
          ),
        ],
      ),
    );
  }
}