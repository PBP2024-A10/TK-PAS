import 'dart:convert';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:ajengan_halal_mobile/cards_makanan/screens/cards_makanan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ajengan_halal_mobile/cards_makanan/models/restaurant_list.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart' as pbp;
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String username = '';

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var request = context.read<pbp.CookieRequest>();
      setState(() {
        if (request.jsonData.containsKey('username')) {
          username = request.jsonData['username'];
        }
      });
    });
  }

  Future<List<RestaurantList>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/makanan/restaurant_list_json/'));

    if (response.statusCode == 200) {
      List<RestaurantList> data = restaurantListFromJson(response.body);
      setState(() {
        allRestaurants = data;
        filteredRestaurants = data; // Initially same as allRestaurants
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

  bool get isAdmin => username == 'admin';
  bool get isLoggedIn => username.isNotEmpty;

  Future<void> _showAddRestaurantDialog() async {
    _nameController.clear();
    _descController.clear();
    _locationController.clear();
    _imageUrlController.clear();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Restaurant"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addRestaurant(
                  _nameController.text,
                  _descController.text,
                  _locationController.text,
                  _imageUrlController.text,
                );
                Navigator.pop(ctx);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addRestaurant(String name, String description, String location, String imageUrl) async {
    try {
      var request = context.read<pbp.CookieRequest>();
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/makanan/add-restaurant-flutter/"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': request.headers['Cookie'] ?? '',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'location': location,
          'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          futureRestaurants = fetchRestaurants();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add restaurant: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteRestaurantPopup(String id) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete Restaurant"),
          content: const Text("Are you sure you want to delete this restaurant?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _deleteRestaurant(id);
    }
  }

  Future<void> _deleteRestaurant(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("http://127.0.0.1:8000/makanan/delete-restaurant-flutter/$id/"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': context.read<pbp.CookieRequest>().headers['Cookie'] ?? '',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          futureRestaurants = fetchRestaurants();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete restaurant: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) {
      return 5;
    } else if (width >= 992) {
      return 4;
    } else if (width >= 768) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Warna.backgroundcream,
      appBar: AppBar(
        title: const Text('Daftar Restoran'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<RestaurantList>>(
        future: futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // An error occurred
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else {
            // Data is available
            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // If user is admin, show "Add Restaurant" button
                    if (isAdmin)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _showAddRestaurantDialog,
                            child: const Text('Add Restaurant'),
                          ),
                        ),
                      ),

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
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _calculateCrossAxisCount(screenWidth),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.75, // Adjusted for better responsiveness
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
                                          // Restaurant Image
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(
                                                restaurant.fields.imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                    child: const Center(
                                                      child: Icon(Icons.broken_image, color: Colors.white),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            restaurant.fields.name,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04, // Responsive font size
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF927155),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            restaurant.fields.description,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035, // Responsive font size
                                            ),
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Lokasi: ${restaurant.fields.location}",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035, // Responsive font size
                                              fontStyle: FontStyle.italic,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  if (isLoggedIn) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => CardsMakanan(  
                                                        restaurantName: restaurant.fields.name,
                                                        restaurantDescription: restaurant.fields.description,
                                                        restaurantImage: restaurant.fields.imageUrl,
                                                        restaurantId: restaurant.pk, )),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                                    );
                                                  }
                                                },
                                                child: const Text("Show more →", style: TextStyle(fontSize: 12)),
                                              ),
                                              if (isAdmin)
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                                  onPressed: () {
                                                    _deleteRestaurantPopup(restaurant.pk);
                                                  },
                                                ),
                                            ],
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
              },
            );
          }
        },
      ),
    );
  }
}
