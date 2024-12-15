// To parse this JSON data, do
//
//     final editorChoice = editorChoiceFromJson(jsonString);

import 'dart:convert';

List<EditorChoice> editorChoiceFromJson(String str) => List<EditorChoice>.from(json.decode(str).map((x) => EditorChoice.fromJson(x)));

String editorChoiceToJson(List<EditorChoice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EditorChoice {
    String model;
    String pk;
    Fields fields;

    EditorChoice({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory EditorChoice.fromJson(Map<String, dynamic> json) => EditorChoice(
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
    DateTime week;
    List<String> foodItems;

    Fields({
        required this.week,
        required this.foodItems,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        week: DateTime.parse(json["week"]),
        foodItems: List<String>.from(json["food_items"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "week": "${week.year.toString().padLeft(4, '0')}-${week.month.toString().padLeft(2, '0')}-${week.day.toString().padLeft(2, '0')}",
        "food_items": List<dynamic>.from(foodItems.map((x) => x)),
    };
}
