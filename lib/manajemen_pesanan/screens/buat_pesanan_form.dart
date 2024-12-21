import 'dart:convert';
import 'package:cards_makanan/manajemen_pesanan/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:cards_makanan/manajemen_pesanan/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BuatPesananForm extends StatefulWidget {
  const BuatPesananForm({super.key});

  @override
  State<BuatPesananForm> createState() => _BuatPesananFormState();
}

class _BuatPesananFormState extends State<BuatPesananForm> {
  final _formKey = GlobalKey<FormState>();
  String _namapenerima = "";
  String _alamatpengiriman = "";
  String _statuspesanan = 'pending';
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    isAdmin = true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.fastfood, color: Colors.black),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat Pesanan Baru",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Penerima
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Nama Penerima:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _namapenerima = value;
                          });
                        },
                        validator: (value) =>
                            value!.isEmpty ? "Nama Penerima tidak boleh kosong!" : null,
                      ),
                      const SizedBox(height: 16),

                      // Alamat Pengiriman
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Alamat Pengiriman:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _alamatpengiriman = value;
                          });
                        },
                        validator: (value) =>
                            value!.isEmpty ? "Alamat Pengiriman tidak boleh kosong!" : null,
                      ),
                      const SizedBox(height: 16),

                      // Status Pesanan
                      TextFormField(
                        enabled: isAdmin,
                        initialValue: _statuspesanan,
                        decoration: InputDecoration(
                          labelText: "Status Pesanan:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _statuspesanan = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tombol Kirim
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/manajemen-pesanan/orders/new/create-flutter/",
                                jsonEncode(<String, String>{
                                  'nama_penerima': _namapenerima,
                                  'alamat_pengiriman': _alamatpengiriman,
                                  'status_pesanan': _statuspesanan,
                                }),
                              );

                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Pesanan baru berhasil disimpan!"),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Terdapat kesalahan, silakan coba lagi."),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF471B00),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Mengatur ukuran rounded corner
                            ),
                          ),
                          child: const Text(
                            "Kirim Pesanan",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Link "Kembali ke Daftar Pesanan"
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list_pesanan');
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF9F6D4C),
              ),
              child: const Text(
                "Kembali ke Daftar Pesanan",
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}