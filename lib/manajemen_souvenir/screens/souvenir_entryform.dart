import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/models/souvenir_entry.dart';
import 'package:http/http.dart' as http;

class SouvenirEntryFormPage extends StatefulWidget {
  final SouvenirEntry? initialSouvenirEntry;

  const SouvenirEntryFormPage({Key? key, this.initialSouvenirEntry}) : super(key: key);

  @override
  State<SouvenirEntryFormPage> createState() => _SouvenirEntryFormPageState();
}

class _SouvenirEntryFormPageState extends State<SouvenirEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _souvenir = "";
  String _description = "";
  String _imageURL = "";

  @override
  void initState() {
    super.initState();
    if (widget.initialSouvenirEntry != null) {
      _souvenir = widget.initialSouvenirEntry!.fields.name;
      _description = widget.initialSouvenirEntry!.fields.description;
      _imageURL = widget.initialSouvenirEntry!.fields.image;
    }
  }

  Future<void> _submitToDjango() async {
    // final url = (widget.initialSouvenirEntry == null)
    //     ? Uri.parse('http://localhost:8000/souvenir/flutter/add-souvenir_entry/')
    //     : Uri.parse('http://localhost:8000/souvenir/flutter/edit-souvenir/${widget.initialSouvenirEntry!.pk}/');

    // http.Response response;
    // final body = jsonEncode({
    //   'name': _souvenir,
    //   'description': _description,
    //   'image': _imageURL,
    // });

    // if (widget.initialSouvenirEntry == null) {
    //   response = await http.post(
    //     url,
    //     headers: {'Content-Type': 'application/json'},
    //     body: body,
    //   );
    // } else {
    //   response = await http.put(
    //     url,
    //     headers: {'Content-Type': 'application/json'},
    //     body: body,
    //   );
    // }

    // if ((widget.initialSouvenirEntry == null && response.statusCode == 201) ||
    //     (widget.initialSouvenirEntry != null && response.statusCode == 200)) {
    //   final newEntry = SouvenirEntry(
    //     pk: widget.initialSouvenirEntry?.pk ?? DateTime.now().millisecondsSinceEpoch.toString(),
    //     model: Model.MANAJEMEN_SOUVENIR_SOUVENIR_ENTRY,
    //     fields: Fields(
    //       name: _souvenir,
    //       description: _description,
    //       image: _imageURL,
    //     ),
    //   );

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Souvenir berhasil disimpan ke server!')),
    //   );
    // Buat objek SouvenirEntry tanpa melakukan POST
    final newEntry = SouvenirEntry(
      pk: widget.initialSouvenirEntry?.pk ?? DateTime.now().millisecondsSinceEpoch.toString(),
      model: Model.MANAJEMEN_SOUVENIR_SOUVENIR_ENTRY,
      fields: Fields(
        name: _souvenir,
        description: _description,
        image: _imageURL,
      ),
    );

    // Kembalikan newEntry ke parent
    Navigator.pop(context, newEntry);
    //   Navigator.pop(context, newEntry);
    // } else {
    //   final data = jsonDecode(response.body);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Gagal menyimpan: ${data["message"]}')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.initialSouvenirEntry == null ? 'Tambah Oleh-Oleh' : 'Edit Oleh-Oleh',
          style: const TextStyle(
            fontFamily: 'Poppins', // Menggunakan font Poppins
            fontWeight: FontWeight.w600, // Menyesuaikan dengan desain
            fontSize: 24, // Ukuran font sesuai kebutuhan
            color: Color(0xFF3D200A), // Warna teks sesuai tema
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3D200A),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Nama Souvenir
                  const Text(
                    'Nama',
                    style: TextStyle(
                      color: Color(0xFF3D200A),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    initialValue: _souvenir,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE8DCD4),
                      hintText: "Masukkan Nama Oleh-Oleh",
                      hintStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF462009)),
                      ),
                    ),
                    onChanged: (value) {
                      _souvenir = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: Color(0xFF3D200A),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    initialValue: _description,
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE8DCD4),
                      hintText: "Masukkan Deskripsi Oleh-Oleh",
                      hintStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF462009)),
                      ),
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Gambar
                  const Text(
                    'Gambar',
                    style: TextStyle(
                      color: Color(0xFF3D200A),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    initialValue: _imageURL,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE8DCD4),
                      hintText: "Masukkan URL Gambar Oleh-Oleh",
                      hintStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF462009)),
                      ),
                    ),
                    onChanged: (value) {
                      _imageURL = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "URL gambar tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 80), // Memberi ruang untuk tombol di bawah
                ],
              ),
            ),

            // Tombol di pojok kanan bawah
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD10F0F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF462009),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _submitToDjango();
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
