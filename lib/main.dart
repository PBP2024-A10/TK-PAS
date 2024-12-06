import 'package:flutter/material.dart';
import 'screens/cards_makanan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MenuItem(
        restaurantList: 'Ayam Betutu Ibu Nia',
      ), // Mengarahkan ke halaman cards_makanan.dart
    );
  }
}
