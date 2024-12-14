import 'package:flutter/material.dart';
import 'package:cards_makanan/manajemen_pesanan/models/model_food_order.dart';
import 'package:cards_makanan/manajemen_pesanan/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListPesananPage extends StatefulWidget {
  const ListPesananPage({super.key});

  @override
  State<ListPesananPage> createState() => _ListPesananPageState();
}

class _ListPesananPageState extends State<ListPesananPage> {
  Future<List<FoodOrder>> fetchPesanan(CookieRequest request) async {
    // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://localhost:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object FoodOrder
    List<FoodOrder> listPesanan = [];
    for (var d in data) {
      if (d != null) {
        listPesanan.add(FoodOrder.fromJson(d));
      }
    }
    return listPesanan;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchPesanan(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data pesanan pada ajengan halal.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.namapenerima}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Text("${snapshot.data![index].fields.nama}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.alamatpengiriman}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.statuspesanan}")
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
