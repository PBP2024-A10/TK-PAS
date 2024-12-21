import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/widgets/card_souvenir.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/screens/souvenir_entryform.dart';
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
    final response = await http.get(Uri.parse('http://localhost:8000/souvenir/json/'));

    if (response.statusCode == 200) {
      return souvenirEntryFromJson(response.body);
    } else {
      throw Exception('Failed to load souvenirs');
    }
  }

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

    if (response.statusCode == 201) {
      setState(() {
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil ditambahkan!')),
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah souvenir: ${data["message"]}')),
      );
    }
  }

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

    if (response.statusCode == 200) {
      setState(() {
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil diubah!')),
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit souvenir: ${data["message"]}')),
      );
    }
  }

  Future<void> deleteSouvenir(String pk) async {
    final url = Uri.parse('http://localhost:8000/souvenir/flutter/delete/$pk/');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        futureSouvenirs = fetchSouvenirs();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil dihapus!')),
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus souvenir: ${data["message"]}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Oleh-Oleh',
          style: TextStyle(
            color: Color(0xFF462009),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF462009),
        elevation: 0,
      ),
      body: FutureBuilder<List<SouvenirEntry>>(
        future: futureSouvenirs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data souvenir.'));
          } else {
            final souvenirs = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: souvenirs.length,
                    itemBuilder: (context, index) {
                      final souvenir = souvenirs[index];
                      return CardSouvenir(
                        souvenir: souvenir,
                        isAdmin: isAdmin,
                        onEdit: () async {
                          final updatedEntry = await Navigator.push<SouvenirEntry>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SouvenirEntryFormPage(
                                initialSouvenirEntry: souvenir,
                              ),
                            ),
                          );

                          if (updatedEntry != null) {
                            await editSouvenir(
                              souvenir.pk,
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
                                content: Text('Apakah Anda yakin ingin menghapus "${souvenir.fields.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await deleteSouvenir(souvenir.pk);
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
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF462009),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
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
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }
}
