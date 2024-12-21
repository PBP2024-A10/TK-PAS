// To parse this JSON data, do
//
//     final foodComment = foodCommentFromJson(jsonString);

import 'dart:convert';

List<FoodComment> foodCommentFromJson(String str) => List<FoodComment>.from(json.decode(str).map((x) => FoodComment.fromJson(x)));

String foodCommentToJson(List<FoodComment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodComment {
    String model;
    String pk;
    Fields fields;

    FoodComment({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodComment.fromJson(Map<String, dynamic> json) => FoodComment(
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
    int author;
    String authorUname;
    String comment;
    DateTime timestamp;

    Fields({
        required this.foodItem,
        required this.author,
        required this.authorUname,
        required this.comment,
        required this.timestamp,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        foodItem: json["food_item"],
        author: json["author"],
        authorUname: json["author_uname"],
        comment: json["comment"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "food_item": foodItem,
        "author": author,
        "author_uname": authorUname,
        "comment": comment,
        "timestamp": timestamp.toIso8601String(),
    };
}
