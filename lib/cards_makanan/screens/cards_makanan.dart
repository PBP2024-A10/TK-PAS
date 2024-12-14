import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cards_makanan/cards_makanan/models/menu_item.dart'; // Import model MenuItem
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:cards_makanan/manajemen_pesanan/screens/buat_pesanan_form.dart'; // Import halaman BuatPesananForm


void main() {
  runApp(MaterialApp(
    // MaterialApp berada di sini untuk memulai aplikasi
    title: '[Nama Restaurant]',
    theme: ThemeData(
      primarySwatch: Colors.orange, // Gunakan warna utama yang valid
    ),
    home: const CardsMakanan(), // Langsung menuju CardsMakanan
  ));
}

class CardsMakanan extends StatefulWidget {
  const CardsMakanan({Key? key}) : super(key: key);

  @override
  _CardsMakananState createState() => _CardsMakananState();
}

class _CardsMakananState extends State<CardsMakanan> {
  TextEditingController _searchController =
      TextEditingController(); // Controller untuk search bar
  String _searchQuery = ""; // Variabel untuk kata kunci pencarian
  List<MenuItem> _menuItems = []; // Daftar menu yang diambil dari API atau JSON

  // Fungsi untuk memuat data JSON
  Future<void> fetchMenuItems() async {
    final String jsonString =
        await rootBundle.loadString('assets/restaurants.json');
    final List<dynamic> data = json.decode(jsonString); // Dekode JSON
    setState(() {
      _menuItems = data
          .map((item) => MenuItem.fromJson(item))
          .toList(); // Konversi JSON ke list MenuItem
    });
  }

  // Fungsi untuk memfilter menu berdasarkan pencarian nama
  List<MenuItem> _filterMenuItems() {
    if (_searchQuery.isEmpty) {
      return _menuItems; // Jika pencarian kosong, kembalikan semua item
    }
    return _menuItems.where((item) {
      return item.fields.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList(); // Filter berdasarkan nama menu
  }

  @override
  void initState() {
    super.initState();
    fetchMenuItems(); // Memuat data menu saat aplikasi dimulai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('[Nama Restaurant]'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Pencarian sudah ditangani dengan onChanged pada TextField
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '[Deskripsi Restaurant]',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by menu name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update kata kunci pencarian
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _menuItems.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Dua kolom per baris
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8, // Proporsi kartu
                      ),
                      itemCount: _filterMenuItems().length,
                      itemBuilder: (context, index) {
                        final item = _filterMenuItems()[index];
                        return _buildMenuCard(
                          imageUrl:
                              item.fields.imageUrlMenu, // Gambar dari JSON
                          name: item.fields.name, // Nama makanan
                          price: 'Rp${item.fields.price}', // Harga makanan
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan kartu menu
  Widget _buildMenuCard({
    required String imageUrl,
    required String name,
    required String price,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red, size: 40),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          // Tambahkan logika untuk ikon hati di sini
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          // Navigasi ke halaman BuatPesananForm
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BuatPesananForm()),
                          );
                        },
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
}