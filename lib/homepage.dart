import 'dart:convert';
import 'package:ajengan_halal_mobile/cards_makanan/screens/cards_makanan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ajengan_halal_mobile/cards_makanan/models/restaurant_list.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<RestaurantList>> futureRestaurants;
  List<RestaurantList> allRestaurants = [];
  List<RestaurantList> filteredRestaurants = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants();
  }

  Future<List<RestaurantList>> fetchRestaurants() async {
    // Ganti URL dengan endpoint API Django Anda
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/makanan/restaurant_list_json/'));

    if (response.statusCode == 200) {
      List<RestaurantList> data = restaurantListFromJson(response.body);
      setState(() {
        allRestaurants = data;
        filteredRestaurants = data; // Awalannya sama
      });
      return data;
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  void _filterRestaurants(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredRestaurants = allRestaurants;
      });
    } else {
      setState(() {
        filteredRestaurants = allRestaurants
            .where((restaurant) =>
                restaurant.fields.name.toLowerCase().contains(query.toLowerCase()) ||
                restaurant.fields.description.toLowerCase().contains(query.toLowerCase()) ||
                restaurant.fields.location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Restoran'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<RestaurantList>>(
        future: futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Jika terjadi error
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else {
            // Jika data sudah tersedia
            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterRestaurants(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Cari restoran...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredRestaurants.isEmpty
                      ? const Center(child: Text("Belum ada data restoran."))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 card per row
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8, // Atur rasio agar tampil sesuai kebutuhan
                            ),
                            itemCount: filteredRestaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = filteredRestaurants[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Gambar restoran
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          restaurant.fields.imageUrl,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              height: 80,
                                              child: const Center(
                                                child: Icon(Icons.broken_image, color: Colors.white),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        restaurant.fields.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF927155),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        restaurant.fields.description,
                                        style: const TextStyle(fontSize: 12),
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Lokasi: ${restaurant.fields.location}",
                                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const CardsMakanan()),
                                            );
                                          },
                                          child: const Text("Show more →", style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
