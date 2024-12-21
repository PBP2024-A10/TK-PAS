import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:ajengan_halal_mobile/manajemen_pesanan/widgets/left_drawer.dart';
import 'package:ajengan_halal_mobile/manajemen_pesanan/screens/lihat_detail.dart';

class FoodOrder {
  final String pk;
  final Fields fields;

  FoodOrder({required this.pk, required this.fields});

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      pk: json['pk'],
      fields: Fields.fromJson(json['fields']),
    );
  }
}

class Fields {
  final String namaPenerima;
  final String alamatPengiriman;
  final String statusPesanan;

  Fields({
    required this.namaPenerima,
    required this.alamatPengiriman,
    required this.statusPesanan,
  });

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      namaPenerima: json['nama_penerima'],
      alamatPengiriman: json['alamat_pengiriman'],
      statusPesanan: json['status_pesanan'],
    );
  }
}

class ListPesananPage extends StatefulWidget {
  const ListPesananPage({super.key});

  @override
  State<ListPesananPage> createState() => _ListPesananPageState();
}

class _ListPesananPageState extends State<ListPesananPage> {

  @override
  void initState() {
    super.initState();
  fetchPesanan(context.read<CookieRequest>());
  }

  Future<List<FoodOrder>> fetchPesanan(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/manajemen-pesanan/orders/json/');
    var data = jsonDecode(response);

    List<FoodOrder> listPesanan = [];
    for (var d in data) {
      listPesanan.add(FoodOrder.fromJson(d));
    }
    return listPesanan;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Hamburger menu
              color: Colors.black, // Warna ikon hamburger
              onPressed: () {
                Scaffold.of(context).openDrawer();
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
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFEBD9D2),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          // Judul DAFTAR PESANAN
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'DAFTAR PESANAN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Aksi ketika tombol ditekan
                  Navigator.pushNamed(context, '/buat_pesanan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF471B00), // Warna tombol
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Mengatur ukuran rounded corner
                  ),
                ),
                child: const Text(
                  'Buat Pesanan Baru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // FutureBuilder untuk List Pesanan
// FutureBuilder untuk List Pesanan
Expanded(
  child: RefreshIndicator(
    onRefresh: () => fetchPesanan(context.read<CookieRequest>()),
    child: FutureBuilder(
      future: fetchPesanan(request),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data pesanan.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                var order = snapshot.data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      const TextSpan(
                                        text: 'Pesanan ID: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: snapshot.data[index].pk),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Nama Penerima
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      const TextSpan(
                                        text: 'Nama Penerima: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: order.fields.namaPenerima),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Alamat Pengiriman
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      const TextSpan(
                                        text: 'Alamat Pengiriman: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: order.fields.alamatPengiriman),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Status Pesanan
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      const TextSpan(
                                        text: 'Status Pesanan: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: order.fields.statusPesanan),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // Navigate to detail page with order details
                                        Navigator.pushNamed(
                                          context,
                                          '/lihat_detail',
                                          arguments: {
                                            'pk': order.pk,
                                            'productData': {
                                              'nama_penerima': order.fields.namaPenerima,
                                              'alamat_pengiriman': order.fields.alamatPengiriman,
                                              'status_pesanan': order.fields.statusPesanan,
                                            }
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Lihat Detail',
                                        style: TextStyle(color: Color(0xFF9F6D4C)),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/update_status',
                                          arguments: {
                                            'pk': order.pk,
                                            'productData': {
                                              'nama_penerima': order.fields.namaPenerima,
                                              'alamat_pengiriman': order.fields.alamatPengiriman,
                                              'status_pesanan': order.fields.statusPesanan,
                                            }
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Update',
                                        style: TextStyle(color: Color(0xFF9F6D4C)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    ),
  ),
),

        ],
      ),
    );
  }
}