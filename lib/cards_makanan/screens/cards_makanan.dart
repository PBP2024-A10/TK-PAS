import 'dart:convert'; // Untuk decoding JSON
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/restaurant_list.dart';

class RestaurantMenuPage extends StatefulWidget {
  final RestaurantList restaurant;

  const RestaurantMenuPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  TextEditingController _searchController =
      TextEditingController(); // Controller untuk search bar
  String _searchQuery = ""; // Variabel untuk kata kunci pencarian
  List<MenuItem> _menuItems = []; // Daftar menu yang diambil dari API atau JSON
  Map<String, List<MenuItem>> _groupedMenuItems =
      {}; // Menyimpan menu yang dikelompokkan berdasarkan restoran
  String? _selectedRestaurantName; // Nama restoran yang dipilih

  // Fungsi untuk memuat data JSON
  Future<void> fetchMenuItems() async {
    final String jsonString =
        await rootBundle.loadString('assets/restaurants.json');
    final List<MenuItem> menuItems = menuItemsFromJson(jsonString);

    // Mengelompokkan menu berdasarkan restoran
    final groupedItems = await fetchAndGroupMenuItems();

    setState(() {
      _menuItems = menuItems;
      _groupedMenuItems = groupedItems;
    });
  }

  // Fungsi untuk memfilter menu berdasarkan restoran yang dipilih dan pencarian nama menu
  List<MenuItem> _filterMenuItems() {
    if (_selectedRestaurantName == null || _selectedRestaurantName!.isEmpty) {
      return []; // Jika restoran belum dipilih, kembalikan daftar kosong
    }
    List<MenuItem> filteredByRestaurant =
        _groupedMenuItems[_selectedRestaurantName] ?? [];
    if (_searchQuery.isEmpty) {
      return filteredByRestaurant; // Jika pencarian kosong, kembalikan semua menu dari restoran yang dipilih
    }
    // Filter berdasarkan nama menu
    return filteredByRestaurant.where((item) {
      return item.fields.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Fungsi untuk menangani pemilihan restoran
  void _onRestaurantClick(String restaurantName) {
    setState(() {
      _selectedRestaurantName =
          restaurantName; // Set nama restoran yang dipilih
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMenuItems(); // Memuat data menu saat aplikasi dimulai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update search query
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Restoran List (Pada homepage, ini adalah daftar restoran dalam bentuk card)
          Expanded(
            child: ListView.builder(
              itemCount: _groupedMenuItems.keys.length,
              itemBuilder: (context, index) {
                String restaurantName = _groupedMenuItems.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => _onRestaurantClick(restaurantName),
                  child: Card(
                    child: ListTile(
                      title: Text(restaurantName),
                    ),
                  ),
                );
              },
            ),
          ),
          // Daftar Menu
          Expanded(
            child: _selectedRestaurantName == null
                ? Center(child: Text('Pilih restoran untuk melihat menu'))
                : ListView.builder(
                    itemCount: _filterMenuItems().length,
                    itemBuilder: (context, index) {
                      MenuItem item = _filterMenuItems()[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: item.fields.imageUrlMenu.isNotEmpty
                              ? Image.network(item.fields.imageUrlMenu,
                                  width: 50, height: 50)
                              : Icon(Icons
                                  .restaurant_menu), // Menampilkan gambar atau icon jika gambar tidak ada
                          title: Text(item.fields.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.fields.description),
                              Text('${item.fields.price} IDR'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}