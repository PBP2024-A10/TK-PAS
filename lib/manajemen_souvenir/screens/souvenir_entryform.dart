// souvenir_entryform.dart
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
    final url = (widget.initialSouvenirEntry == null)
        ? Uri.parse('http://localhost:8000/souvenir/flutter/add-souvenir_entry/') 
        : Uri.parse('http://localhost:8000/souvenir/flutter/edit-souvenir/${widget.initialSouvenirEntry!.pk}/'); 

    http.Response response;
    final body = jsonEncode({
      'name': _souvenir,
      'description': _description,
      'image': _imageURL,
    });

    if (widget.initialSouvenirEntry == null) {
      // Mode tambah (POST)
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } else {
      // Mode edit (PUT)
      response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    }

    if ((widget.initialSouvenirEntry == null && response.statusCode == 201) ||
        (widget.initialSouvenirEntry != null && response.statusCode == 200)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir berhasil disimpan ke server!')),
      );

      final newEntry = SouvenirEntry(
        pk: widget.initialSouvenirEntry?.pk ?? DateTime.now().millisecondsSinceEpoch.toString(),
        model: Model.MANAJEMEN_SOUVENIR_SOUVENIR_ENTRY,
        fields: Fields(
          name: _souvenir,
          description: _description,
          image: _imageURL,
        ),
      );

      Navigator.pop(context, newEntry);
    } else {
      // Jika gagal, tampilkan pesan error dari response body Django
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: ${data["message"]}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialSouvenirEntry == null 
          ? 'Form Tambah Oleh-Oleh' 
          : 'Form Edit Oleh-Oleh'),
        backgroundColor: const Color(0xFF3D200A),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Nama Souvenir
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _souvenir,
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama Oleh-Oleh",
                    labelText: "Nama Oleh-Oleh",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    _souvenir = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Oleh-Oleh tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    hintText: "Masukkan Deskripsi Oleh-Oleh",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
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
              ),

              // URL Gambar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _imageURL,
                  decoration: InputDecoration(
                    hintText: "Masukkan URL Gambar Oleh-Oleh",
                    labelText: "Gambar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    _imageURL = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Gambar tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Tombol Simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF3D200A)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _submitToDjango();
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
