import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/food_recommendation.dart'; // Model untuk FoodRecommendation
import 'package:ajengan_halal_mobile/editors_choice/models/editor_choice.dart'; // Model untuk EditorChoice
import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart'; // Model untuk MenuItem
import 'package:ajengan_halal_mobile/editors_choice/screens/week_edlist.dart'; // Halaman untuk menampilkan daftar EditorChoice
import 'package:http/http.dart' as http; // Library untuk melakukan HTTP request

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
  int _totalFoodRec = 0; // Jumlah total FoodRecommendation yang akan dihitung nanti

  @override
  void initState() {
    super.initState();
    _futureEditorChoices = fetchEditorChoices(widget.week);
  }

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
        ? 'http://localhost:8000/editors-choice/json/editor-choice/'
        : 'http://localhost:8000/editors-choice/json/editor-choice/week/$week'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/editor-choice/
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/editor-choice/week/$week

    // Jika kedua response berhasil (status code 200)
    if (responseEC.statusCode == 200 &&
        responseFR.statusCode == 200 &&
        responseMI.statusCode == 200) {
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
                  Image.asset('assets/images/cross-mark-no-data.png',
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
                  Image.asset('assets/images/cross-mark-no-data.png',
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
                    itemCount: editorChoices.length, // Jumlah EditorChoice

                    itemBuilder: (context, index) {
                      final editorChoice = editorChoices.keys
                          .elementAt(index); // EditorChoice saat ini
                      final foodRecommendations = editorChoices[
                          editorChoice]!; // Daftar FoodRecommendation terkait

                      return ListTile(
                        title: Text(editorChoice.fields.week
                            .toIso8601String()), // Menampilkan tanggal minggu EditorChoice
                        subtitle: Text(
                            'Food Recommendations: ${foodRecommendations.length}'), // Menampilkan jumlah rekomendasi makanan
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeekEdList(),
                        )
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A230A), // Warna cokelat
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Sudut melengkung
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, // Padding atas & bawah
                        horizontal: 24, // Padding kiri & kanan
                      ),
                    ),
                    child: const Text('View Weekly Editor Choices'),
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
