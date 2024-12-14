import 'package:flutter/material.dart';
import 'package:cards_makanan/cards_makanan/screens/cards_makanan.dart';
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
            colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.brown,
          ).copyWith(secondary: Colors.brown[300]),
          ),
          home: const CardsMakanan(),
        ));
  }
}