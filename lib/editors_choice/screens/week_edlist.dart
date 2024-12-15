import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart'; // Import widget navbar untuk drawer navigasi
import 'package:ajengan_halal_mobile/editors_choice/models/editor_choice.dart'; // Model untuk EditorChoice
import 'package:http/http.dart' as http; // Library untuk melakukan HTTP request
import 'package:ajengan_halal_mobile/editors_choice/screens/editors_choice_main.dart'; // Halaman utama Editor's Choice

// Widget Stateful untuk halaman utama Editor's Choices list
class WeekEdList extends StatefulWidget {
  const WeekEdList({super.key});

  @override
  _WeekEdListState createState() => _WeekEdListState();
}

class _WeekEdListState extends State<WeekEdList> {
  // Future untuk menyimpan data EditorChoice
  late Future<List<EditorChoice>> _futureEditorChoices;

  @override
  void initState() {
    super.initState();
    _futureEditorChoices = fetchEditorChoices();
  }

  // Fungsi untuk mengambil data EditorChoice dari API
  Future<List<EditorChoice>> fetchEditorChoices() async {
    // HTTP GET request untuk mengambil data EditorChoice
    final responseEC = await http.get(
        Uri.parse('http://localhost:8000/editors-choice/json/editor-choice/'));
    // Endpoint asli: https://rafansyadaryltama-ajenganhalal.pbp.cs.ui.ac.id/editors-choice/json/editor-choice/

    // Jika response berhasil (status code 200)
    if (responseEC.statusCode == 200) {
      // Parsing JSON dari response untuk EditorChoice
      final Map<String, EditorChoice> result = {};

      for (var target in editorChoiceFromJson(responseEC.body)) {
        result.putIfAbsent(target.fields.week.toIso8601String(), () => target);
      }

      return result.values.toList();
    } else {
      // Jika response gagal, lempar error
      throw Exception('Failed to load editor choice');
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

      body: FutureBuilder<List<EditorChoice>>(
        future: _futureEditorChoices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].fields.week.toString()),
                  subtitle: Text(snapshot.data![index].pk.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditorsChoiceMain(
                          week: snapshot.data![index].fields.week
                              .toIso8601String()
                              .substring(0, 10),
                        ),
                      ),
                    );
                  },
                );
              },
            );
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
