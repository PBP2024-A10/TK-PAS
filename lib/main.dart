import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              left: 9,
              top: 120,
              child: Text(
                'Ayam Betutu Ibu Nia',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF462009),
                  height: 1.2,
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: 156,
              child: Text(
                'Restoran khas Bali yang terkenal dengan Ayam Betutu',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF462009),
                  height: 1.2,
                ),
              ),
            ),
            Positioned(
              left: 29,
              top: 206,
              child: Container(
                width: 337,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF6B7280)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFF462009),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Search Menu',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                        color: Color(0xFF462009),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 207,
              top: 276,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  'https://via.placeholder.com/168x176',
                  width: 168,
                  height: 176,
                ),
              ),
            ),
            Positioned(
              left: 339,
              top: 284,
              child: Stack(
                children: [
                  Container(
                    width: 31,
                    height: 31.46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  Positioned(
                    left: 4.13,
                    top: 1.83,
                    child: Image.network(
                      'https://via.placeholder.com/23x30',
                      width: 22.73,
                      height: 30.17,
                    ),
                  ),
                  Positioned(
                    left: -1.72,
                    top: 0,
                    child: Container(
                      width: 32.21,
                      height: 31.94,
                      decoration: BoxDecoration(
                        color: Color(0xFFFC0505),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 200,
              top: 482,
              child: Text(
                'Rp50.000',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Color(0xFF5D4D3B),
                ),
              ),
            ),
            // Duplicate the rest of the content as needed using similar Positioned widget
            // e.g., adding more images, text, and containers
          ],
        ),
      ),
    );
  }
}
