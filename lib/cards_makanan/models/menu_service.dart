// import 'dart:convert';
// import 'package:ajengan_halal_mobile/cards_makanan/models/menu_item.dart';
// import 'package:http/http.dart' as http;

// Future<List<MenuItem>> fetchMenuForRestaurant(String restaurantId) async {
//   try {
//     final response = await http.get(
//       Uri.parse('https://api.example.com/restaurants/$restaurantId/menu'),
//       headers: {
//         'Accept': 'application/json', // Menambahkan header untuk memastikan response berupa JSON
//       },
//     );

//     if (response.statusCode == 200) {
//       final body = response.body;

//       // Validasi bahwa response body bukan null atau kosong
//       if (body.isEmpty) {
//         throw Exception('Response body kosong.');
//       }

//       final data = jsonDecode(body);

//       // Validasi apakah data adalah list
//       if (data is! List) {
//         throw Exception('Format data yang diterima tidak sesuai (bukan list).');
//       }

//       return data.map((item) {
//         try {
//           // Cek apakah kunci ada dan pastikan tipe data sesuai
//           final id = item['id'] ?? '';
//           final name = item['name'] ?? 'Unnamed Item';
//           final description = item['description'] ?? 'No Description';
//           final imageUrl = item['image_url'] ?? '';
//           final price = item['price'] is num ? (item['price'] as num).toDouble() : 0.0;

//           return MenuItem(
//             id: id,
//             name: name,
//             description: description,
//             imageUrl: imageUrl,
//             price: price,
//           );
//         } catch (e) {
//           throw Exception('Error mem-parsing item menu: $e');
//         }
//       }).toList();

//     } else {
//       throw Exception(
//           'Gagal mengambil data menu. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Terjadi kesalahan saat mengambil data menu: $e');
//   }
// }
