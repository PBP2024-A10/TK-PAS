import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/food_recommendation.dart'; // Model untuk FoodRecommendation
import 'package:ajengan_halal_mobile/editors_choice/models/editor_choice.dart'; // Model untuk EditorChoice
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:ajengan_halal_mobile/editors_choice/screens/week_edlist.dart'; // Halaman untuk menampilkan daftar EditorChoice
import 'package:ajengan_halal_mobile/editors_choice/screens/food_rec_page.dart'; // Halaman untuk menampilkan detail FoodRecommendation
import 'package:http/http.dart' as http; // Library untuk melakukan HTTP request
import 'package:pbp_django_auth/pbp_django_auth.dart'
    as pbp; // Library untuk melakukan HTTP request
import 'package:provider/provider.dart'; // Library untuk state management

// Widget Stateful untuk halaman utama Editor's Choice
class EditorsChoiceMain extends StatefulWidget {
  final String? week; // Filter "week" untuk EditorChoice
  const EditorsChoiceMain({super.key, this.week});

  @override
  _EditorsChoiceMainState createState() => _EditorsChoiceMainState();
}

class _EditorsChoiceMainState extends State<EditorsChoiceMain> {
  // Future untuk menyimpan data EditorChoice dan FoodRecommendation
  late Future<Map<EditorChoice, List<Map<FoodRecommendation, MenuItem>>>>
      _futureEditorChoices;
  int _totalFoodRec =
      0; // Jumlah total FoodRecommendation yang akan dihitung nanti
  String _defWeek = ''; // Minggu default
  String username = ''; // Nama pengguna

  String getDefaultWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return firstDayOfWeek.toIso8601String().substring(0, 10);
  }

  @override
  void initState() {
    super.initState();
    _futureEditorChoices = fetchEditorChoices(widget.week);
    _defWeek = getDefaultWeek();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var request = context.read<pbp.CookieRequest>();
      setState(() {
        if (request.jsonData.containsKey('username')) {
          username = request.jsonData['username'];
        }
      });
    });
  }

  // bool get isAdmin => username == 'admin'; // Cek apakah pengguna adalah admin
  bool get isAdmin => username == 'admin1'; // Cek apakah pengguna adalah admin
  bool get isLoggedIn => username.isNotEmpty; // Cek apakah pengguna sudah login

  // Fungsi untuk mengambil data EditorChoice dan FoodRecommendation dari API
  Future<Map<EditorChoice, List<Map<FoodRecommendation, MenuItem>>>>
      fetchEditorChoices(String? week) async {
    // HTTP GET request untuk mengambil data FoodRecommendation
    final responseFR = await http
        .get(Uri.parse('http://localhost:8000/editors-choice/json/food-rec/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food-rec/

    // HTTP GET request untuk mengambil data MenuItem <- digunakan untuk menampilkan detail makanan dari FoodRecommendation
    final responseMI = await http
        .get(Uri.parse('http://localhost:8000/editors-choice/json/food/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/food/

    // HTTP GET request untuk mengambil data EditorChoice
    final responseEC = await http.get(Uri.parse(week == null
        // ? 'http://localhost:8000/editors-choice/json/editor-choice/week/$_defWeek/' // used
        ? 'http://localhost:8000/editors-choice/json/editor-choice/week/2024-12-02/' // DEBUG
        : 'http://localhost:8000/editors-choice/json/editor-choice/week/$week/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/editor-choice/
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/editor-choice/week/$week/

    // Jika kedua response berhasil (status code 200 / 301)
    if ((responseEC.statusCode == 200 || responseEC.statusCode == 301) &&
        (responseFR.statusCode == 200 || responseFR.statusCode == 301) &&
        (responseMI.statusCode == 200 || responseMI.statusCode == 301)) {
      // Parsing JSON dari response untuk FoodRecommendation
      final List<FoodRecommendation> foodRecommendations =
          foodRecommendationFromJson(responseFR.body);

      // Parsing JSON dari response untuk EditorChoice
      final List<EditorChoice> fetchedEdChoice =
          editorChoiceFromJson(responseEC.body);

      // Parsing JSON dari response untuk MenuItem
      final List<MenuItem> fetchedMenuItems =
          menuItemsFromJson(responseMI.body);

      // Membuat mapping MenuItem berdasarkan primary key untuk pencarian cepat
      final Map<String, MenuItem> menuItemMap = {
        for (var menuItem in fetchedMenuItems) menuItem.pk: menuItem
      };

      // Membuat mapping FoodRecommendation ke MenuItem
      final Map<FoodRecommendation, MenuItem>
          foodRecommendationsForEditorChoice = {
        for (var foodRecommendation in foodRecommendations)
          if (menuItemMap.containsKey(foodRecommendation.fields.foodItem))
            foodRecommendation: menuItemMap[foodRecommendation.fields.foodItem]!
      };

      // Membuat mapping EditorChoice ke daftar FoodRecommendation
      final Map<EditorChoice, List<Map<FoodRecommendation, MenuItem>>> result =
          {};

      for (final editorChoice in fetchedEdChoice) {
        // Daftar FoodRecommendation yang sesuai dengan EditorChoice
        final List<Map<FoodRecommendation, MenuItem>> temp = [];

        for (final foodRecommendation
            in foodRecommendationsForEditorChoice.keys) {
          // Menambahkan FoodRecommendation jika ID (primary key) ditemukan
          if (editorChoice.fields.foodItems.contains(foodRecommendation.pk)) {
            temp.add({
              foodRecommendation:
                  foodRecommendationsForEditorChoice[foodRecommendation]!
            });
            _totalFoodRec++; // Menambahkan jumlah total FoodRecommendation
          }
        }

        // Memasukkan EditorChoice dan daftar FoodRecommendation ke dalam map
        result[editorChoice] = temp;
      }

      return result;
    } else {
      // Jika gagal, lemparkan Exception
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk memfilter EditorChoice berdasarkan tipe makanan
  void _filterEditorChoicesByFoodType(String? type) {
    setState(() {
      _futureEditorChoices = _futureEditorChoices.then((data) {
        if (type == null || type.isEmpty) {
          return data;
        } else {
          final filteredData = <EditorChoice, List<Map<FoodRecommendation, MenuItem>>>{};
          data.forEach((editorChoice, foodList) {
            final filteredFoodList = foodList.where((foodMap) {
              final foodItem = foodMap.values.first;
              return foodItem.fields.mealType == type;
            }).toList();
            if (filteredFoodList.isNotEmpty) {
              filteredData[editorChoice] = filteredFoodList;
            }
          });
          return filteredData;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editors Choice'), // Judul di AppBar
        backgroundColor: const Color(0xFF3D200A), // Warna latar belakang AppBar
        iconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon di AppBar
      ),

      drawer: const LeftDrawer(), // Drawer navigasi di sebelah kiri

      body: FutureBuilder<
          Map<EditorChoice, List<Map<FoodRecommendation, MenuItem>>>>(
        future: _futureEditorChoices, // Future yang memuat data

        builder: (context, snapshot) {
          // Menampilkan loading spinner saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menangani error jika terjadi masalah saat mengambil data
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/cross-mark-no-data.png',
                      width: 100, height: 100),
                  const SizedBox(height: 16),
                  Text(
                      'Error: Failed to load data. Error message: ${snapshot.error}'),
                ],
              ),
            );
          }
          // Menampilkan pesan jika data kosong
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/cross-mark-no-data.png',
                      width: 100, height: 100),
                  const SizedBox(height: 16),
                  const Text('No data available'),
                ],
              ),
            );
          }
          // Jika data berhasil dimuat
          else {
            final editorChoices =
                snapshot.data!; // Data EditorChoice dan FoodRecommendation

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ListView untuk menampilkan EditorChoice dan jumlah FoodRecommendation
                  ListView.builder(
                    shrinkWrap:
                        true, // Menyesuaikan tinggi ListView dengan konten
                    physics:
                        const NeverScrollableScrollPhysics(), // ListView tidak bisa discroll secara independen
                    itemCount: _totalFoodRec, // Jumlah EditorChoice

                    itemBuilder: (context, index) {
                      final week = editorChoices.keys
                          .elementAt(0); // Minggu yang terpilih
                      final editorChoice = editorChoices
                          .values; // EditorChoice lists pada minggu yang terpilih
                      final List<FoodRecommendation> foodRecommendations = [];
                      final List<MenuItem> foodItems = [];
                      for (var temp in editorChoice) {
                        for (var foodRec in temp) {
                          foodRecommendations.add(foodRec.keys.toList()[0]);
                          foodItems.add(foodRec.values.toList()[0]);
                        }
                      }

                      return Column(children: [
                        // Card untuk menampilkan EditorChoice
                        InkWell(
                          onTap: () {
                            // Navigasi ke halaman detail FoodRecommendation tertentu (rekomendasi makanan)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodRecommendationPage(
                                  id: foodItems[index].pk,
                                  foodItem: foodItems[index].fields.name,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(children: [
                              ListTile(
                                title: Text(
                                  'Week ${week.fields.week}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Food: ${foodItems[index].fields.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ]);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeekEdList(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A230A), // Warna cokelat
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Sudut melengkung
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, // Padding atas & bawah
                        horizontal: 24, // Padding kiri & kanan
                      ),
                    ),
                    child: const Text('View Weekly Editor Choices'),
                  ),
                  if (isAdmin) // to be changed to "Add Food Recommendation"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeekEdList(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF4A230A), // Warna cokelat
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Sudut melengkung
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12, // Padding atas & bawah
                          horizontal: 24, // Padding kiri & kanan
                        ),
                      ),
                      child: const Text('View Weekly Editor Choices'),
                    ),
                  if (isAdmin) // to be changed to "Delete Food Recommendation"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeekEdList(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF4A230A), // Warna cokelat
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Sudut melengkung
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12, // Padding atas & bawah
                          horizontal: 24, // Padding kiri & kanan
                        ),
                      ),
                      child: const Text('View Weekly Editor Choices'),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total Food Recommendations: $_totalFoodRec',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
