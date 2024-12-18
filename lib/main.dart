import 'package:cards_makanan/manajemen_pesanan/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/list_pesanan.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/update_status.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/lihat_detail.dart';
import 'package:cards_makanan/manajemen_pesanan/screens/buat_pesanan_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ajengan Halal',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown)
              .copyWith(secondary: Colors.brown[300]),
        ),
        routes: {
          '/buat_pesanan': (context) => const BuatPesananForm(),
          '/list_pesanan': (context) => const ListPesananPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/lihat_detail') {
            try {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) {
                  return LihatDetailPage(
                    pk: args['pk'],
                    productData: args['productData'],
                  );
                },
              );
            } catch (e) {
                print("Error: $e");
                return null; // Atau arahkan ke halaman error jika diperlukan
            }
            }
          if (settings.name == '/update_status') {
            try {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) {
                  return UpdateStatus(
                    pk: args['pk'],
                    productData: args['productData'],
                  );
                },
              );
            } catch (e) {
                print("Error: $e");
                return null; // Atau arahkan ke halaman error jika diperlukan
            }
            }
          return null; // Lanjutkan rute lainnya
        },
        home: MyHomePage(),
      ),
    );
  }
}