import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/wishlists.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  Future<WishLists> fetchWishLists(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/wishlist/get-wishlists/');

    WishLists wishLists = WishLists.fromJson(response);

    return wishLists;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wish List"),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchWishLists(request), 
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if ((!snapshot.hasData)) {
              return const Column(
                children: [
                  Text(
                    'Tidak berhasil mendapatkan data',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              WishLists data = snapshot.data!;
              List<Wishlist> wishLists = data.wishlists!;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Adjust the aspect ratio to prevent overflow
                ),
                itemCount: wishLists.length,
                itemBuilder: (_, index) {
                  Wishlist wishlist = wishLists[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    padding: const EdgeInsets.all(7.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${wishlist.name}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Limit to one line
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Description: ${wishlist.description}",
                          maxLines: 2, // Limit to two lines
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Price: ${wishlist.price}",
                          maxLines: 1, // Limit to one line
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Type: ${wishlist.mealType}",
                          maxLines: 1, // Limit to one line
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: wishlist.imageUrlMenu != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    wishlist.imageUrlMenu!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "No Image Available",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Restaurant: ${wishlist.restaurant}",
                          maxLines: 1, // Limit to one line
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        }
      ),
    );
  }
}