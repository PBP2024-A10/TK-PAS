import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart';
import 'package:ajengan_halal_mobile/wishlist/models/wishlists.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ajengan_halal_mobile/manajemen_pesanan/screens/buat_pesanan_form.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';

class CardsMakanan extends StatefulWidget {
  final String restaurantName;
  final String restaurantDescription;
  final String restaurantImage;
  final String restaurantId;  // Tambah parameter restaurant ID

  const CardsMakanan({
    Key? key, 
    required this.restaurantName,
    required this.restaurantDescription,
    required this.restaurantImage,
    required this.restaurantId,
  }) : super(key: key);

  @override
  _CardsMakananState createState() => _CardsMakananState();
}

class _CardsMakananState extends State<CardsMakanan> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List<MenuItem> _menuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  List<Wishlist> _wishLists = [];
  late CookieRequest request;
  bool _isLoading = true;  // Tambah loading state

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/makanan/menu-items-json/${widget.restaurantId}/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _menuItems = data.map((item) => MenuItem.fromJson(item)).toList();
          _filteredMenuItems = _menuItems;
          _isLoading = false;  // Set loading ke false setelah data dimuat
        });
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;  // Set loading ke false jika terjadi error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading menu items: $e')),
      );
    }
  }

  void _filterMenuItems() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredMenuItems = _menuItems;
      });
    } else {
      setState(() {
        _filteredMenuItems = _menuItems.where((item) {
          return item.fields.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchWishLists(context.read<CookieRequest>());
    });
  }

  @override
  Widget build(BuildContext context) {
    request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Warna.white,
      appBar: AppBar(
        title: Text(widget.restaurantName),
        backgroundColor: Warna.backgroundcream,
      ),
      drawer: const LeftDrawer(),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.restaurantDescription,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search menu items',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterMenuItems();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filteredMenuItems.isEmpty
                        ? const Center(child: Text('No menu items found'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredMenuItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredMenuItems[index];
                              bool isWishListed = _wishLists
                                  .any((wish) => wish.name == item.fields.name);
                              
                              return _buildMenuCard(
                                imageUrl: item.fields.imageUrlMenu,
                                name: item.fields.name,
                                price: 'Rp${item.fields.price}',
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
        jsonEncode({
            'menu_item_name' : name
        }),
    );
    if (context.mounted) {
        if (response['error'] == null) {
          String message = "";
          if (response['message'] == 'Removed from wishlist') {
            message = "Removed $name from wishlist!";
          } else if (response['message'] == 'Added to wishlist') {
            message = "Added $name to wishlist!";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
              content: Text(message),
          ));
          // Refresh halaman tanpa navigasi ulang
          setState(() {
            fetchWishLists(request);
          });
        } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                content: Text("Terdapat kesalahan, silakan coba lagi."),
            ));
        }
    }
}
  // =================================================================================
}