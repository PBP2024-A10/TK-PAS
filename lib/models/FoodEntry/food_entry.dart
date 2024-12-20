// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
    Model model;
    String pk;
    Fields fields;

    Food({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String description;
    String? location;
    String? imageUrl;
    String? restaurant;
    String? price;
    MealType? mealType;
    String? imageUrlMenu;

    Fields({
        required this.name,
        required this.description,
        this.location,
        this.imageUrl,
        this.restaurant,
        this.price,
        this.mealType,
        this.imageUrlMenu,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        description: json["description"],
        location: json["location"],
        imageUrl: json["image_url"],
        restaurant: json["restaurant"],
        price: json["price"],
        mealType: mealTypeValues.map[json["meal_type"]]!,
        imageUrlMenu: json["image_url_menu"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "location": location,
        "image_url": imageUrl,
        "restaurant": restaurant,
        "price": price,
        "meal_type": mealTypeValues.reverse[mealType],
        "image_url_menu": imageUrlMenu,
    };
}

enum MealType {
    BREAKFAST,
    DINNER,
    LUNCH
}

final mealTypeValues = EnumValues({
    "Breakfast": MealType.BREAKFAST,
    "Dinner": MealType.DINNER,
    "Lunch": MealType.LUNCH
});

enum Model {
    CARDS_MAKANAN_MENUITEM,
    CARDS_MAKANAN_RESTAURANT
}

final modelValues = EnumValues({
    "cards_makanan.menuitem": Model.CARDS_MAKANAN_MENUITEM,
    "cards_makanan.restaurant": Model.CARDS_MAKANAN_RESTAURANT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
