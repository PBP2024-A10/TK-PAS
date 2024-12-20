// souvenir.dart
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/screens/souvenir_entryform.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/widgets/card_souvenir.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/models/souvenir_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SouvenirPage extends StatefulWidget {
  const SouvenirPage({Key? key}) : super(key: key);

  @override
  State<SouvenirPage> createState() => _SouvenirListPageState();
}

class _SouvenirListPageState extends State<SouvenirPage> {
  bool isAdmin = true;
  late Future<List<SouvenirEntry>> futureSouvenirs;

  @override
  void initState() {
    super.initState();
    futureSouvenirs = fetchSouvenirs();
  }

  Future<List<SouvenirEntry>> fetchSouvenirs() async {
    // Pastikan URL ini sesuai dengan endpoint show_json di Django
    final response = await http.get(Uri.parse('http://localhost:8000/souvenir/json/')); 
    // print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return souvenirEntryFromJson(response.body);
    } else {
      throw Exception('Failed to load souvenirs');
    }
  }

  // Fungsi untuk menambah souvenir baru (POST)
  Future<void> addSouvenir(String name, String description, String imageUrl) async {
    final url = Uri.parse('http://localhost:8000/souvenir/flutter/add-souvenir_entry/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'image': imageUrl,
      }),
    );

    print('Submit Response Status: ${response.statusCode}');
    print('Submit Response Body: ${response.body}');

    if (response.statusCode == 201) {
      // Berhasil menambah, reload data
      print('Souvenir berhasil ditambahkan!');
      setState(() {
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil ditambahkan!')),
      );
    } else {
      print('Gagal menambah souvenir: ${response.body}');
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah souvenir: ${data["message"]}')),
      );
    }
  }

  // Fungsi untuk mengedit souvenir (PUT)
  Future<void> editSouvenir(String pk, String name, String description, String imageUrl) async {
    final url = Uri.parse('http://localhost:8000/souvenir/flutter/edit-souvenir/$pk/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'image': imageUrl,
      }),
    );

    print('Edit Response Status: ${response.statusCode}');
    print('Edit Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Berhasil mengedit, reload data
      setState(() {
        print('Souvenir berhasil diubah!');
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil diubah!')),
      );
    } else {
      print('Gagal edit souvenir: ${response.body}');
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit souvenir: ${data["message"]}')),
      );
    }
  }

  // Fungsi untuk menghapus souvenir (DELETE)
  // Contoh fungsi untuk menghapus souvenir
  Future<void> deleteSouvenir(String pk) async {
    final url = Uri.parse('http://localhost:8000/souvenir/flutter/delete/$pk/');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Souvenir berhasil dihapus!');
      setState(() {
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil dihapus!')),
      );
    } else {
      print('Gagal menghapus souvenir: ${response.body}');
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus souvenir: ${data["message"]}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Souvenir'),
        backgroundColor: const Color(0xFF3D200A),
        foregroundColor: Colors.white,
        actions: [
          if (isAdmin)
            TextButton(
              onPressed: () async {
                final newEntry = await Navigator.push<SouvenirEntry>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SouvenirEntryFormPage(),
                  ),
                );

                if (newEntry != null) {
                  await addSouvenir(
                    newEntry.fields.name,
                    newEntry.fields.description,
                    newEntry.fields.image,
                  );
                }
              },
              child: const Text(
                'Tambah Souvenir',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<SouvenirEntry>>(
        future: futureSouvenirs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No souvenirs found.'));
          } else {
            final souvenirs = snapshot.data!;
            return ListView.builder(
              itemCount: souvenirs.length,
              itemBuilder: (context, index) {
                final entry = souvenirs[index];

                return CardSouvenir(
                  souvenir: entry,
                  isAdmin: isAdmin,
                  onEdit: () async {
                    final updatedEntry = await Navigator.push<SouvenirEntry>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SouvenirEntryFormPage(
                          initialSouvenirEntry: entry,
                        ),
                      ),
                    );

                    if (updatedEntry != null) {
                      await editSouvenir(
                        entry.pk,
                        updatedEntry.fields.name,
                        updatedEntry.fields.description,
                        updatedEntry.fields.image,
                      );
                    }
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Hapus Souvenir'),
                          content: Text('Apakah Anda yakin ingin menghapus "${entry.fields.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await deleteSouvenir(entry.pk);
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
