// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LihatDetailPage extends StatefulWidget {
  final String pk;  // Pesanan ID yang diterima saat menekan "Lihat Detail"
  final Map<String, dynamic> productData;  // Pesanan ID yang diterima saat menekan "Lihat Detail"

  const LihatDetailPage({Key? key, required this.pk, required this.productData}) : super(key: key);

  @override
  State<LihatDetailPage> createState() => _LihatDetailPageState();
}

class _LihatDetailPageState extends State<LihatDetailPage> {
  String? _namaPenerima;
  String? _alamatPengiriman;
  String? _statusPesanan;

  @override
  void initState() {
    super.initState();
    _namaPenerima = widget.productData['nama_penerima'];
    _alamatPengiriman = widget.productData['alamat_pengiriman'];
    _statusPesanan = widget.productData['status_pesanan'];
  }

  Future<void> deleteProduct(String pk) async {
    // Konfirmasi penghapusan
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus pesanan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Batal
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Lanjutkan
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Jika pengguna tidak setuju, keluar dari fungsi
    if (shouldDelete != true) return;

    try {
      // Kirim permintaan penghapusan ke server
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/manajemen-pesanan/orders/delete/$pk/'),
      );

      if (response.statusCode == 200) {
        // Berhasil dihapus di server
        setState(() {
          // Contoh: Jika Anda punya daftar lokal, hapus itemnya
          // allProducts.removeWhere((product) => product.id_product == pk);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dihapus.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi kembali jika perlu
        Navigator.of(context).pop();
      } else {
        // Jika ada masalah dengan penghapusan
        throw Exception('Gagal menghapus pesanan.');
      }
    } catch (e) {
      // Tampilkan pesan error jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back), // Ikon back di kiri
              color: Colors.black, // Warna ikon back
              onPressed: () {
                Navigator.of(context).pop(); // Aksi kembali
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.fastfood,
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi ID Pesanan
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Detail Pesanan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          const SizedBox(height: 10),

            Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Pesanan ID: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.pk),
                      ],
                    ),
    
                    Row(
                      children: [
                        const Text(
                          'Nama Penerima: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_namaPenerima ?? '-'),
                      ],
                    ),
    
                    Row(
                      children: [
                        const Text(
                          'Alamat Pengiriman: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            _alamatPengiriman ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
    
                    Row(
                      children: [
                        const Text(
                          'Status Pesanan: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _statusPesanan ?? '-',
                          style: TextStyle(
                            color: _statusPesanan == 'delivered'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deleteProduct(widget.pk);
                          },
                          child: const Text(
                            'Hapus Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Mengatur ukuran rounded corner
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/list_pesanan');
                  },
                  child: const Text(
                    'Kembali ke Daftar Pesanan',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF9F6D4C), // Warna teks
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}