// To parse this JSON data, do
//
//     final souvenirEntry = souvenirEntryFromJson(jsonString);

import 'dart:convert';

List<SouvenirEntry> souvenirEntryFromJson(String str) => List<SouvenirEntry>.from(json.decode(str).map((x) => SouvenirEntry.fromJson(x)));

String souvenirEntryToJson(List<SouvenirEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SouvenirEntry {
    String pk;
    Model model;
    Fields fields;

    SouvenirEntry({
        required this.pk,
        required this.model,
        required this.fields,
    });

    factory SouvenirEntry.fromJson(Map<String, dynamic> json) => SouvenirEntry(
        pk: json["pk"],
        model: modelValues.map[json["model"]]!,
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "model": modelValues.reverse[model],
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String description;
    String image;

    Fields({
        required this.name,
        required this.description,
        required this.image,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        description: json["description"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": image,
    };
}

enum Model {
    MANAJEMEN_SOUVENIR_SOUVENIR_ENTRY
}

final modelValues = EnumValues({
    "manajemen_souvenir.SouvenirEntry": Model.MANAJEMEN_SOUVENIR_SOUVENIR_ENTRY
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
