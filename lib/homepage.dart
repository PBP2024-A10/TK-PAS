import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/auth/screens/register.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';


class Homepage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  bool isStaff = false; 

  final List<String> carouselImages = [
    'https://cdn.ngopibareng.id/uploads/2021/2021-10-28/12-makanan-khas-bali-yang-jadi-incaran-wisatawan--02',
    'https://awsimages.detik.net.id/community/media/visual/2022/11/20/rijsttafel-indonesia-2.jpeg?w=1200',
    'https://s3-ap-southeast-1.amazonaws.com/blog-assets.segari.id/2022/10/Ayam-Betutu---Istock.jpg',
  ];

  final List<Map<String, String>> restaurants = [
    {'name': 'Restaurant 1', 'description': 'Description 1', 'imageUrl': 'https://example.com/restaurant1.jpg'},
    {'name': 'Restaurant 2', 'description': 'Description 2', 'imageUrl': 'https://example.com/restaurant2.jpg'},
    {'name': 'Restaurant 3', 'description': 'Description 3', 'imageUrl': 'https://example.com/restaurant3.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage - Daftar Makanan'),
        backgroundColor: Color(0xFF3D200A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://example.com/background-image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: carouselImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),

            // Search bar for restaurants
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Cari restoran...',
                  filled: true,
                  fillColor: Color(0xFFE8DCD4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (query) {
                  // Implement search logic here (for example, filtering restaurants)
                },
              ),
            ),

            // Button "All categories"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle category filter
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D200A),
                  foregroundColor: Color(0xFFE8DCD4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('All categories'),
              ),
            ),

            // Restaurant cards
            GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to restaurant menu
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          restaurant['imageUrl']!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          // borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF927155),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                restaurant['description']!,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (isStaff) ...[
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Handle delete restaurant action
                                  },
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Pagination
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Go to previous page
                    },
                    child: Text('Sebelumnya'),
                    style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF927155)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Go to next page
                    },
                    child: Text('Berikutnya'),
                    style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF927155)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
