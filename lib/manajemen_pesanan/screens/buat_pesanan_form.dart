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
  String _statuspesanan = 'Pending'; // Default status
  bool isAdmin = false; // Flag untuk menentukan apakah user adalah admin

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Pesanan',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Penerima
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Penerima",
                    labelText: "Nama Penerima",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _namapenerima = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama Penerima tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Alamat Pengiriman
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Alamat Pengiriman",
                    labelText: "Alamat Pengiriman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _alamatpengiriman = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Alamat Pengiriman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Status Pesanan (Hanya admin yang bisa mengubahnya)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  enabled: isAdmin, // Status hanya bisa diubah oleh admin
                  initialValue: _statuspesanan,
                  decoration: InputDecoration(
                    labelText: "Status Pesanan",
                    hintText: _statuspesanan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: const Icon(Icons.pending_actions),
                  ),
                  onChanged: (String? value) {
                    if (isAdmin) {
                      setState(() {
                        _statuspesanan = value!;
                      });
                    }
                  },
                ),
              ),

              // Tombol Kirim Pesanan di kiri bawah
              Align(
                alignment: Alignment.bottomLeft, // Align ke kiri bawah
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        final response = await request.postJson(
                          "http://localhost:8000/create-flutter/",
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
                                content:
                                    Text("Pesanan baru berhasil disimpan!"),
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
                                content: Text(
                                  "Terdapat kesalahan, silakan coba lagi.",
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Kirim Pesanan",
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
