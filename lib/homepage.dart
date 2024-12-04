import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ajengan_halal_mobile/models/FoodEntry/food_entry.dart';
import 'base/widgets/navbar.dart';

class Homepage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://cdn.ngopibareng.id/uploads/2021/2021-10-28/12-makanan-khas-bali-yang-jadi-incaran-wisatawan--02',
    'https://awsimages.detik.net.id/community/media/visual/2022/11/20/rijsttafel-indonesia-2.jpeg?w=1200',
    'https://s3-ap-southeast-1.amazonaws.com/blog-assets.segari.id/2022/10/Ayam-Betutu---Istock.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Restoran"),
        backgroundColor: Color(0xFF3D200A),
      ),
      drawer: LeftDrawer(),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         width: double.infinity,
      //         height: 250,
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             image: NetworkImage('https://example.com/background-image.jpg'),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Align(
      //             alignment: Alignment.bottomLeft,
      //             child: Text(
      //               "Daftar Restoran",
      //               style: TextStyle(
      //                 fontSize: 34,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       CarouselSlider(
      //         items: imageUrls.map((url) {
      //           return Container(
      //             child: Image.network(url, fit: BoxFit.cover),
      //           );
      //         }).toList(),
      //         options: CarouselOptions(
      //           autoPlay: true,
      //           enlargeCenterPage: true,
      //           aspectRatio: 16/9,
      //           viewportFraction: 1.0,
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //         child: TextFormField(
      //           decoration: InputDecoration(
      //             labelText: "Cari restoran...",
      //             border: OutlineInputBorder(),
      //             prefixIcon: Icon(Icons.search),
      //           ),
      //           onChanged: (value) {
      //             // Implement search functionality
      //           },
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 16.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Navigate to categories page or perform other action
      //               },
      //               child: Text("All categories"),
      //               // style: ElevatedButton.styleFrom(
      //               //   primary: Color(0xFF3D200A),
      //               //   onPrimary: Colors.white,
      //               // ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       GridView.builder(
      //         shrinkWrap: true,
      //         physics: NeverScrollableScrollPhysics(),
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2,
      //           crossAxisSpacing: 16.0,
      //           mainAxisSpacing: 16.0,
      //         ),
      //         itemCount: restaurants.length,
      //         itemBuilder: (context, index) {
      //           return Card(
      //             elevation: 5,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Image.network(
      //                   restaurants[index]['imageUrl']!,
      //                   height: 120,
      //                   width: double.infinity,
      //                   fit: BoxFit.cover,
      //                 ),
      //                 SizedBox(height: 8),
      //                 Text(
      //                   restaurants[index]['name']!,
      //                   style: TextStyle(fontWeight: FontWeight.bold),
      //                 ),
      //                 SizedBox(height: 4),
      //                 Text(
      //                   restaurants[index]['description']!,
      //                   style: TextStyle(color: Colors.grey),
      //                 ),
      //                 TextButton(
      //                   onPressed: () {
      //                     // Navigate to restaurant menu
      //                   },
      //                   child: Text("Show more →"),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //       // SizedBox(height: 20),
      //       // if (true /* Check if user is staff */)
      //         // Padding(
      //         //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //         //   child: ElevatedButton(
      //         //     onPressed: () {
      //         //       // Navigate to add restaurant page
      //         //     },
      //         //     child: Text("Add Restaurant"),
      //         //     style: ElevatedButton.styleFrom(
      //         //       primary: Color(0xFF927155),
      //         //       onPrimary: Colors.white,
      //         //     ),
      //         //   ),
      //         // ),
      //     ],
      //   ),
      // ),
    
    );
  }
}
