import 'dart:convert';

List<MenuItem> menuItemsFromJson(String str) =>
    List<MenuItem>.from(json.decode(str).map((x) => MenuItem.fromJson(x)));

String menuItemsToJson(List<MenuItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuItem {
  final String model;
  final String pk;
  final Fields fields;

  MenuItem({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        model: json["model"] ?? "Unknown Model", // Nilai default jika null
        pk: json["pk"] ?? "Unknown PK", // Nilai default jika null
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  final String restaurant;
  final String name;
  final String description;
  final String price;
  final String mealType;
  final String imageUrlMenu;

  Fields({
    required this.restaurant,
    required this.name,
    required this.description,
    required this.price,
    required this.mealType,
    required this.imageUrlMenu,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        restaurant: json["restaurant"] ?? "Unknown Restaurant",  // Nilai default jika null
        name: json["name"] ?? "No Name",  // Nilai default jika null
        description: json["description"] ?? "No Description",  // Nilai default jika null
        price: json["price"] ?? "0",  // Nilai default jika null
        mealType: json["meal_type"] ?? "Unknown",  // Nilai default jika null
        imageUrlMenu: json["image_url_menu"] ?? "",  // Nilai default jika null
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