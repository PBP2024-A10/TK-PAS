import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/food_recommendation.dart'; // Model untuk FoodRecommendation
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:ajengan_halal_mobile/editors_choice/models/food_comment.dart'; // Model untuk FoodComment
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
  late Future<Map<Map<FoodRecommendation, MenuItem>, List<FoodComment>>>
      _futureFoodRecommendation;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureFoodRecommendation =
        fetchFoodRecommendation(widget.foodItem, widget.id);
  }

  // Fungsi untuk mengambil data FoodRecommendation dari API
  Future<Map<Map<FoodRecommendation, MenuItem>, List<FoodComment>>>
      fetchFoodRecommendation(String foodItem, String id) async {
    // HTTP GET request untuk mengambil data FoodRecommendation
    final responseFR = await http
        .get(Uri.parse('http://localhost:8000/editors-choice/json/food-rec/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food-recommendation/

    final responseMI = await http
        .get(Uri.parse('http://localhost:8000/editors-choice/json/food/$id'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food/

    // Jika response berhasil (status code 200)
    if (responseFR.statusCode == 200 && responseMI.statusCode == 200) {
      Map<FoodRecommendation, MenuItem> key = {};
      // Parsing JSON dari response untuk FoodRecommendation
      for (var target in foodRecommendationFromJson(responseFR.body)) {
        if (target.fields.foodItem == id) {
          key = {target: menuItemsFromJson(responseMI.body)[0]};
        }
      }

      // Parsing JSON dari response untuk FoodComment
      final recID = key.keys.elementAt(0).pk;
      final responseFC = await http.get(Uri.parse(
          'http://localhost:8000/editors-choice/json/comments/$recID/'));
      // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/comments/$recID/

      // Jika response berhasil (status code 200)
      if (responseFC.statusCode == 200) {
        // Mengembalikan data FoodRecommendation dan FoodComment
        return {key: foodCommentFromJson(responseFC.body)};
      } else {
        // Jika response gagal, lempar error
        throw Exception('Failed to load food comment');
      }
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

      body: Stack(
        children: [
          Expanded(
            child: FutureBuilder<
                Map<Map<FoodRecommendation, MenuItem>, List<FoodComment>>>(
              future: _futureFoodRecommendation,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var foodRec = snapshot.data!.keys.elementAt(index);
                      var comments = snapshot.data![foodRec];

                      return Column(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      foodRec.keys.elementAt(0).fields.foodItem),
                                  subtitle: Text(foodRec.keys
                                      .elementAt(0)
                                      .fields
                                      .ratedDescription),
                                  trailing: Text(foodRec.values
                                      .elementAt(0)
                                      .fields
                                      .price
                                      .toString()),
                                ),
                                ExpansionTile(
                                  title: const Text('Comments'),
                                  children: comments!.map((comment) {
                                    return ListTile(
                                      title: Text(comment.fields.comment),
                                      subtitle: Text(
                                          'Commented at: ${comment.fields.timestamp}'),
                                    );
                                  }).toList(),
                                ),
                                // TextField(
                                //   controller: _commentController,
                                //   decoration: const InputDecoration(
                                //     labelText: 'Add your personal comment',
                                //     hintText: 'Give your thoughts about your best personal experience here',
                                //     border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                                //     ),
                                //     contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                //   ),
                                //   maxLines: null, // Allows for multi-line input
                                //   keyboardType: TextInputType.multiline, // Sets the keyboard type to multiline
                                // ),
                              ],
                            ),
                          ),
                        ],
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Add your personal comment',
                      hintText: 'Give your thoughts about your best personal experience here',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    maxLines: null, // Allows for multi-line input
                    keyboardType: TextInputType.multiline, // Sets the keyboard type to multiline
                  ),
                  ElevatedButton(
                    onPressed: () async { // not quite rightfully implemented yet
                      // final token = Provider.of<pbp.Auth>(context, listen: false).currToken;
                      // final response = await http.post(
                      //   Uri.parse('http://localhost:8000/editors-choice/json/comments/'),
                      //   headers: <String, String>{
                      //     'Content-Type': 'application/json; charset=UTF-8',
                      //     'Authorization': 'Token $token',
                      //   },
                      //   body: jsonEncode(<String, dynamic>{
                      //     'food_item': widget.id,
                      //     'comment': _commentController.text,
                      //   }),
                      // );
                      // if (response.statusCode == 201) {
                      //   setState(() {
                      //     _futureFoodRecommendation =
                      //         fetchFoodRecommendation(widget.foodItem, widget.id);
                      //   });
                      // } else {
                      //   throw Exception('Failed to post comment');
                      // }
                    },
                    child: const Text('Post Comment'),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
