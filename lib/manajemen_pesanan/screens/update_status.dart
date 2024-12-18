import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UpdateStatus extends StatefulWidget {
  final String pk;  // Pesanan ID yang diterima saat menekan "Lihat Detail"
  final Map<String, dynamic> productData;  // Pesanan ID yang diterima saat menekan "Lihat Detail"

  const UpdateStatus({Key? key, required this.pk, required this.productData}) : super(key: key);

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  late TextEditingController _statusController;
  String? _namaPenerima;
  String? _alamatPengiriman;
  String? _statusPesanan;
  
  // Daftar status yang valid
  final List<String> statusOptions = ['pending', 'preparing', 'delivered', 'cancelled'];
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _namaPenerima = widget.productData['nama_penerima'];
    _alamatPengiriman = widget.productData['alamat_pengiriman'];
    _statusPesanan = widget.productData['status_pesanan'];
    
    // Set status yang dipilih sesuai status yang ada sebelumnya
    _selectedStatus = _statusPesanan;
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengupdate status pesanan
  Future<void> _updateStatus() async {
    final url = Uri.parse('http://127.0.0.1:8000/manajemen-pesanan/orders/update/${widget.pk}/'); // Ganti URL dengan API Anda
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status_pesanan': _selectedStatus}), // Data yang dikirim ke server
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _statusPesanan = _selectedStatus; // Update status lokal
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status pesanan berhasil diperbarui!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status pesanan!')),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Update Status',
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
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Update Status Pesanan",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown untuk update status
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: "Status Pesanan Baru",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tombol Submit
                    ElevatedButton(
                      onPressed: _updateStatus,
                      child: const Text("Update Status"),
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