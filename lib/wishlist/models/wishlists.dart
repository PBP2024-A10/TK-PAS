// To parse this JSON data, do
//
//     final wishLists = wishListsFromJson(jsonString);

import 'dart:convert';

WishLists wishListsFromJson(String str) => WishLists.fromJson(json.decode(str));

String wishListsToJson(WishLists data) => json.encode(data.toJson());

class WishLists {
    List<Wishlist>? wishlists;

    WishLists({
        this.wishlists,
    });

    factory WishLists.fromJson(Map<String, dynamic> json) => WishLists(
        wishlists: List<Wishlist>.from(json["wishlists"].map((x) => Wishlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "wishlists": List<dynamic>.from(wishlists!.map((x) => x.toJson())),
    };
}

class Wishlist {
    String? id;
    String? restaurant;
    String? name;
    String? description;
    double? price; // Change from int to double
    String? mealType;
    String? imageUrlMenu;

    Wishlist({
        this.id,
        this.restaurant,
        this.name,
        this.description,
        this.price,
        this.mealType,
        this.imageUrlMenu,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json['id'],
        restaurant: json["restaurant"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        mealType: json["meal_type"],
        imageUrlMenu: json["image_url_menu"],
    );

    Map<String, dynamic> toJson() => {
        'id' : id,
        "restaurant": restaurant,
        "name": name,
        "description": description,
        "price": price,
        "meal_type": mealType,
        "image_url_menu": imageUrlMenu,
    };
}
