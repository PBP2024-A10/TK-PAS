import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cards_makanan/cards_makanan/models/menu_item.dart'; // Import model MenuItem
import 'package:flutter/services.dart' show rootBundle;

class CardsMakanan extends StatelessWidget {
  const CardsMakanan({Key? key}) : super(key: key);

  // Fungsi untuk memuat data JSON
  Future<List<MenuItem>> fetchMenuItems() async {
    // Baca file JSON dari folder assets
    final String jsonString = await rootBundle.loadString('assets/restaurants.json');
    // Parse JSON menjadi list model MenuItem
    return menuItemsFromJson(jsonString);
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
              // Tambahkan logika pencarian di sini
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '[Deskripsi Restoran]',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Menu',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Tambahkan logika pencarian di sini
              },
            ),
            const SizedBox(height: 16),
            Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: fetchMenuItems(), // Panggil fungsi untuk memuat data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No menu items available.'));
                }

                // Filter untuk hanya menampilkan data dengan model "cards_makanan.menuitem" dan harga > 0
                final menuItems = snapshot.data!
                    .where((item) {
                      // Filter berdasarkan model dan harga lebih dari Rp0
                      final price = item.fields.price;
                      final parsedPrice = double.tryParse(price);
                      return item.model == "cards_makanan.menuitem" && parsedPrice != null && parsedPrice > 0;
                    })
                    
                    .toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dua kolom per baris
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8, // Proporsi kartu
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuCard(
                      imageUrl: item.fields.imageUrlMenu, // Gambar dari JSON
                      name: item.fields.name, // Nama makanan
                      price: 'Rp${item.fields.price}', // Harga makanan
                    );
                  },
                );
              },
            ),
          )
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      // Tambahkan logika untuk item menu di sini
                    },
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
