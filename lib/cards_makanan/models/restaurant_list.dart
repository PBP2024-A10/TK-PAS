// To parse this JSON data, do
//
//     final restaurantList = restaurantListFromJson(jsonString);

import 'dart:convert';

List<RestaurantList> restaurantListFromJson(String str) => List<RestaurantList>.from(json.decode(str).map((x) => RestaurantList.fromJson(x)));

String restaurantListToJson(List<RestaurantList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantList {
    String model;
    String pk;
    Fields fields;

    RestaurantList({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
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
    String name;
    String description;
    String location;
    String imageUrl;

    Fields({
        required this.name,
        required this.description,
        required this.location,
        required this.imageUrl,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        description: json["description"],
        location: json["location"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "location": location,
        "image_url": imageUrl,
    };
}