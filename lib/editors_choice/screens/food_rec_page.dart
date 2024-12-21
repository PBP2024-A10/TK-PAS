import 'dart:convert'; // Library untuk mengkonversi JSON
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart'; // Import halaman login
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/food_recommendation.dart'; // Model untuk FoodRecommendation
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:ajengan_halal_mobile/editors_choice/models/food_comment.dart'; // Model untuk FoodComment
import 'package:ajengan_halal_mobile/manajemen_pesanan/screens/buat_pesanan_form.dart'; // Import halaman buat pesanan
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
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _recID = '';

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
      _recID = recID;
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

  // Fungsi untuk mengedit rating
  Future<void> editRating(BuildContext context, String newRating) async {
    if (double.tryParse(newRating) == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Rating'),
            content: const Text('Rating must be a valid number.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    double ratingValue = double.parse(newRating);
    if (ratingValue < 0 || ratingValue > 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Rating'),
            content: const Text('Rating must be between 0 and 5.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    
    final request = context.read<pbp.CookieRequest>();
    final response = await http.post(
      Uri.parse('http://localhost:8000/editors-choice/edit-rating-mobile/?rec_id=$_recID'),
      // Uri.parse('https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/edit-rating-mobile/?rec_id=$_recID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': request.headers['cookie'] ?? '',
        'X-CSRFToken': request.cookies['csrftoken'].toString(),
      },
      body: jsonEncode(<String, String>{
        "new_rating": newRating,
      }),
    );

    final responseJson = jsonDecode(response.body);
    if (context.mounted) {
      Navigator.of(context).pop();
      if (responseJson['status'] == 'success') {
        setState(() {
          _futureFoodRecommendation =
              fetchFoodRecommendation(widget.foodItem, widget.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Rating berhasil diubah."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terdapat kesalahan dalam mengubah rating."),
          ),
        );
      }
    }
    _ratingController.clear();
  }

  // Fungsi untuk mengedit deskripsi
  Future<void> editDescription(BuildContext context, String newDescription) async {
    if (newDescription.contains(RegExp(r'<[^>]*>'))) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Description'),
          content: const Text('Description contains invalid characters.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final request = context.read<pbp.CookieRequest>();
    final response = await http.post(
      Uri.parse('http://localhost:8000/editors-choice/edit-description-mobile/?rec_id=$_recID'),
      // Uri.parse('https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/edit-description-mobile/?rec_id=$_recID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': request.headers['cookie'] ?? '',
        'X-CSRFToken': request.cookies['csrftoken'].toString(),
      },
      body: jsonEncode(<String, String>{
        "new_description": newDescription,
      }),
    );

    final responseJson = jsonDecode(response.body);
    if (context.mounted) {
      Navigator.of(context).pop();
      if (responseJson['status'] == 'success') {
        setState(() {
          _futureFoodRecommendation =
              fetchFoodRecommendation(widget.foodItem, widget.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Description berhasil diubah."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terdapat kesalahan dalam mengubah description."),
          ),
        );
      }
    }
    _descController.clear();
  }

  // Fungsi untuk memberikan komentar
  Future<void> postComment(BuildContext context) async {
    if (_commentController.text.contains(RegExp(r'<[^>]*>'))) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Comment'),
          content: const Text('Comment contains invalid characters.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final request = context.read<pbp.CookieRequest>();
    final response = await http.post(
      Uri.parse(
          'http://localhost:8000/editors-choice/add-comment/?rec_id=$_recID'),
      // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/add-comment/?rec_id=$_recID
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': request.headers['cookie'] ?? '',
        'X-CSRFToken': request.cookies['csrftoken'].toString(),
      },
      body: jsonEncode(<String, String>{
        "rec_id": _recID,
        "comment": _commentController.text,
        "username": request.jsonData['username'],
      }),
    );

    final responseJson = jsonDecode(response.body);
    if (context.mounted) {
      if (responseJson['status'] == 'success') {
        setState(() {
          _futureFoodRecommendation =
              fetchFoodRecommendation(widget.foodItem, widget.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Komentar berhasil dikirim. Komentar baru Anda sudah bisa dilihat!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terdapat kesalahan dalam mengirim komentar."),
          ),
        );
      }
    }
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<pbp.CookieRequest>();

    List<Widget> bottomMenuItems = [
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Column(
            children: [
              if (request.jsonData['username'] != null) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Add your personal comment',
                          hintText:
                              'Give your thoughts about your best personal experience here',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        ),
                        maxLines: null, // Allows for multi-line input
                        keyboardType: TextInputType
                            .multiline, // Sets the keyboard type to multiline
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              request.jsonData['username'] != null) {
                            postComment(context);
                          }
                        },
                        child: const Text('Post Comment'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (request.jsonData['role'] == 'admin') ...[
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Edit Rating'),
                            content: TextField(
                              controller: _ratingController,
                              decoration: const InputDecoration(
                                labelText: 'Enter new rating',
                                hintText: 'Rating (0-5)',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => editRating(
                                    context, _ratingController.text),
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Edit Rating'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Edit Description'),
                            content: TextField(
                              controller: _descController,
                              decoration: const InputDecoration(
                                labelText: 'Enter new description',
                                hintText: 'Description is limited to 5000 characters',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => editDescription(
                                    context, _descController.text),
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Edit Description'),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuatPesananForm(),
                      ),
                    );
                  },
                  child: const Text(
                    'Order Now',
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
                // if (is)
              ] else ...[
                // List tile untuk login/register jika belum login
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login to post comment and make order',
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          )
        ),
      ),
    ];

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
                                  title: Text(foodRec.keys
                                      .elementAt(0)
                                      .fields
                                      .foodItem),
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
                                  title: Text('Comments (${comments!.length})'),
                                  children: comments.map((comment) {
                                    return ListTile(
                                      title: Text(comment.fields.comment),
                                      subtitle: Text(
                                          'Commented at: ${comment.fields.timestamp}'),
                                      trailing: Text(
                                          'by ${comment.fields.authorUname}'),
                                    );
                                  }).toList(),
                                ),
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
          ...bottomMenuItems,
        ],
      ),
    );
  }
}
