// To parse this JSON data, do
//
//     final foodRecommendation = foodRecommendationFromJson(jsonString);

import 'dart:convert';

List<FoodRecommendation> foodRecommendationFromJson(String str) => List<FoodRecommendation>.from(json.decode(str).map((x) => FoodRecommendation.fromJson(x)));

String foodRecommendationToJson(List<FoodRecommendation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodRecommendation {
    String model;
    String pk;
    Fields fields;

    FoodRecommendation({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodRecommendation.fromJson(Map<String, dynamic> json) => FoodRecommendation(
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
    String foodItem;
    double rating;
    int author;
    String authorUname;
    String ratedDescription;
    int commentCount;

    Fields({
        required this.foodItem,
        required this.rating,
        required this.author,
        required this.authorUname,
        required this.ratedDescription,
        required this.commentCount,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        foodItem: json["food_item"],
        rating: json["rating"]?.toDouble(),
        author: json["author"],
        authorUname: json["author_uname"],
        ratedDescription: json["rated_description"],
        commentCount: json["comment_count"],
    );

    Map<String, dynamic> toJson() => {
        "food_item": foodItem,
        "rating": rating,
        "author": author,
        "author_uname": authorUname,
        "rated_description": ratedDescription,
        "comment_count": commentCount,
    };
}
