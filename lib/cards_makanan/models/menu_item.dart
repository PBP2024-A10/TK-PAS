// To parse this JSON data, do
//
//     final menuItem = menuItemFromJson(jsonString);

import 'dart:convert';

List<MenuItem> menuItemFromJson(String str) => List<MenuItem>.from(json.decode(str).map((x) => MenuItem.fromJson(x)));

String menuItemToJson(List<MenuItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuItem {
    String model;
    String pk;
    Fields fields;

    MenuItem({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String restaurant;
    String name;
    String description;
    String price;
    String mealType;
    String imageUrlMenu;

    Fields({
        required this.restaurant,
        required this.name,
        required this.description,
        required this.price,
        required this.mealType,
        required this.imageUrlMenu,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        restaurant: json["restaurant"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        mealType: json["meal_type"],
        imageUrlMenu: json["image_url_menu"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant": restaurant,
        "name": name,
        "description": description,
        "price": price,
        "meal_type": mealType,
        "image_url_menu": imageUrlMenu,
    };
}
