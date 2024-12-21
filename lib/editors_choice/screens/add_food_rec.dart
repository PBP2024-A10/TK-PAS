import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:ajengan_halal_mobile/editors_choice/screens/editors_choice_main.dart'; // Halaman utama Editor's Choice
import 'package:http/http.dart' as http; // Library untuk melakukan HTTP request
import 'package:pbp_django_auth/pbp_django_auth.dart'
    as pbp; // Library untuk melakukan HTTP request
import 'package:provider/provider.dart'; // Import provider package

// Widget Stateful untuk halaman utama Add Food Recommendation
class AddRecommendationPage extends StatefulWidget {
  const AddRecommendationPage({super.key});

  @override
  _AddRecommendationPage createState() => _AddRecommendationPage();
}

// Class untuk state dari AddRecommendationPage
class _AddRecommendationPage extends State<AddRecommendationPage> {
  late Future<Map<String, MenuItem>> _futureMenuItems;
  final _formKey = GlobalKey<FormState>();
  final Map<String, MenuItem> _selectedMenuItems = {};
  double _rating = 0.0;
  String _description = '';

  @override
  void initState() {
    super.initState();
    _futureMenuItems = fetchMenuItems();
  }

  // Fungsi untuk mengambil data MenuItem dari API, digunakan untuk menampilkan daftar makanan
  Future<Map<String, MenuItem>> fetchMenuItems() async {
    // HTTP GET request untuk mengambil data MenuItem
    final responseMI = await http
        .get(Uri.parse('http://localhost:8000/editors-choice/json/food/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/menu-item/

    // Jika response berhasil (status code 200)
    if (responseMI.statusCode == 200) {
      // Parsing JSON dari response untuk MenuItem
      final Map<String, MenuItem> result = {};

      for (var target in menuItemsFromJson(responseMI.body)) {
        result.putIfAbsent(target.fields.name, () => target);
      }

      return result;
    } else {
      // Jika response gagal, lempar error
      throw Exception('Failed to load menu item');
    }
  }

  // Fungsi untuk mendapatkan request dari provider
  pbp.CookieRequest get request => context.read<pbp.CookieRequest>();

  // Fungsi untuk submit form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (request.jsonData['username'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please login as admin to add food recommendation')),
        );
        return;
      }

      // Send the data to the API
      final responseData = await http.post(
        Uri.parse('http://localhost:8000/editors-choice/add-food-mobile/'),
        // Uri.parse('https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/add-food-mobile/'),
        body: jsonEncode({
          'food_id': _selectedMenuItems.values.first.pk,
          'rating': _rating,
          'author': request.jsonData['username'],
          'rated_description': _description,
        }),
      );

      final response = jsonDecode(responseData.body);

      if (mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Food recommendation added successfully')),
          );
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EditorsChoiceMain()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to add food recommendation, details: ${response['detail']}')),
          );
        }
      }
    }
  }

  // Validate rating
  String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a rating';
    }
    final rating = double.tryParse(value);
    if (rating == null || rating < 0 || rating > 5) {
      return 'Please enter a valid rating between 0 and 5';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Food Recommendation Form'), // Judul di AppBar
        backgroundColor: const Color(0xFF3D200A), // Warna latar belakang AppBar
        iconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon di AppBar
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Dropdown untuk memilih makanan
              FutureBuilder<Map<String, MenuItem>>(
                future: _futureMenuItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        items: snapshot.data!.keys
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedMenuItems[value!] = snapshot.data![value]!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a food item';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Food Item',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              // TextFormField untuk rating
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    hintText: 'Enter a rating between 0 and 5',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    _rating = double.parse(value!);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rating';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid rating';
                    } else if (double.parse(value) < 0 ||
                        double.parse(value) > 5) {
                      return 'Please enter a valid rating between 0 and 5';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // TextFormField untuk deskripsi, XSS prevention
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rated Description',
                    alignLabelWithHint: true,
                    hintText:
                        "Enter a rated description, maximum 5000 characters",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    _description = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rated description';
                    }
                    if (value.length > 5000) {
                      return 'Description cannot exceed 5000 characters';
                    }
                    // Check for XSS scripting
                    final xssPattern = RegExp(r'<[^>]*>', caseSensitive: false);
                    if (xssPattern.hasMatch(value)) {
                      return 'Description contains invalid characters';
                    }
                    return null;
                  },
                  maxLines:
                      10, // Increase the number of lines to make it visually bigger
                ),
              ),
              const SizedBox(height: 16),
              // Button to clear the form
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.reset();
                  setState(() {
                    _selectedMenuItems.clear();
                    _rating = 0.0;
                    _description = '';
                  });
                },
                child: const Text('Clear'),
              ),
              const SizedBox(height: 16),
              // Button to submit the form
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
