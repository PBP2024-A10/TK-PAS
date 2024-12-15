import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart';
import 'package:ajengan_halal_mobile/wishlist/models/wishlists.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

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
  List<Wishlist> _wishLists = [];
  late CookieRequest request; // for Wishlist

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
    request = context.watch<CookieRequest>(); // for WishList
    fetchWishLists(request); // for WishList

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
      drawer: const LeftDrawer(),
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

                        bool isWishListed = false;
                        for (var i in _wishLists) {
                          if (item.fields.name == i.name) {
                            isWishListed = true;
                            break;
                          }
                        }
                        return _buildMenuCard(
                          imageUrl:
                              item.fields.imageUrlMenu, // Gambar dari JSON
                          name: item.fields.name, // Nama makanan
                          price: 'Rp${item.fields.price}', // Harga makanan
                          isWishListed: isWishListed,
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
    required bool isWishListed,
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
                        icon: Icon(
                          Icons.favorite, 
                          color: isWishListed == true 
                            ? Colors.red
                            : Colors.grey
                        ),
                        onPressed: () {
                          // Tambahkan logika untuk ikon hati di sini
                          onWishList(request, name);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          // Tambahkan logika untuk tombol tambah ('+') di sini
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



  // OLAV'S METHODS
  // =================================================================================
  Future<void> fetchWishLists(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/wishlist/get-wishlists/');
    WishLists wishLists = WishLists.fromJson(response);
    setState(() {
      _wishLists = wishLists.wishlists!;
    });
  }

  Future<void> onWishList(CookieRequest request, String name) async {
    final response = await request.postJson(
        "http://127.0.0.1:8000/wishlist/toggle-wishlist/",
        jsonEncode(<String, String>{
            'menu_item_name' : name
        }),
    );
    if (context.mounted) {
        if (response['error'] == null) {
          String message = "";
          if (response['message'] == 'Removed from wishlist') {
            message = "Remove ${name} to wish list!";
          } else if (response['message'] == 'Added to wishlist') {
            message = "Added ${name} to wish list!";
          }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
            content: Text(message),
            ));
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CardsMakanan()),
            );
        } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                content:
                    Text("Terdapat kesalahan, silakan coba lagi."),
            ));
        }
    }
  }
  // =================================================================================
}