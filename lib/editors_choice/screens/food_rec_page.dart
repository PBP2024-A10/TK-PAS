import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/food_recommendation.dart'; // Model untuk FoodRecommendation
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:http/http.dart' as http; // Library untuk melakukan HTTP request
import 'package:pbp_django_auth/pbp_django_auth.dart'
    as pbp; // Library untuk melakukan HTTP request
import 'package:provider/provider.dart'; // Library untuk state management

// Widget Stateful untuk halaman utama Food Recommendation
class FoodRecommendationPage extends StatefulWidget {
  final String foodItem;
  final String id;
  const FoodRecommendationPage(
      {super.key, required this.foodItem, required this.id});

  @override
  _FoodRecommendationPageState createState() => _FoodRecommendationPageState();
}

class _FoodRecommendationPageState extends State<FoodRecommendationPage> {
  // Future untuk menyimpan data FoodRecommendation
  late Future<Map<FoodRecommendation, MenuItem>> _futureFoodRecommendation;

  @override
  void initState() {
    super.initState();
    _futureFoodRecommendation =
        fetchFoodRecommendation(widget.foodItem, widget.id);
  }

  // Fungsi untuk mengambil data FoodRecommendation dari API
  Future<Map<FoodRecommendation, MenuItem>> fetchFoodRecommendation(
      String foodItem, String id) async {
    // HTTP GET request untuk mengambil data FoodRecommendation
    final responseFR = await http.get(Uri.parse(
      'http://localhost:8000/editors-choice/json/food-rec/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food-recommendation/

    final responseMI = await http.get(Uri.parse(
      'http://localhost:8000/editors-choice/json/food/$id'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food/

    // Jika response berhasil (status code 200)
    if (responseFR.statusCode == 200) {
      Map<FoodRecommendation, MenuItem> result = {};
      // Parsing JSON dari response untuk FoodRecommendation
      for (var target in foodRecommendationFromJson(responseFR.body)) {
        if (target.fields.foodItem == id) {
          result = {target: menuItemsFromJson(responseMI.body)[0]};
        }
      }
      return result;
    } else {
      // Jika response gagal, lempar error
      throw Exception('Failed to load food recommendation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recommendation'), // Judul di AppBar
        backgroundColor: const Color(0xFF3D200A), // Warna latar belakang AppBar
        iconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon di AppBar
      ),

      drawer: const LeftDrawer(), // Drawer navigasi di sebelah kiri

      body: FutureBuilder<Map<FoodRecommendation, MenuItem>>(
        future: _futureFoodRecommendation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data!.keys.elementAt(index).fields.foodItem),
                    subtitle: Text(snapshot.data!.keys.elementAt(index).fields.ratedDescription),
                    trailing: Text(snapshot.data!.values.elementAt(index).fields.price.toString()),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
