// To parse this JSON data, do
//
//     final foodOrder = foodOrderFromJson(jsonString);

import 'dart:convert';

List<FoodOrder> foodOrderFromJson(String str) => List<FoodOrder>.from(json.decode(str).map((x) => FoodOrder.fromJson(x)));

String foodOrderToJson(List<FoodOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodOrder {
    String model;
    String pk;
    Fields fields;

    FoodOrder({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodOrder.fromJson(Map<String, dynamic> json) => FoodOrder(
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
    int user;
    String namaPenerima;
    String alamatPengiriman;
    DateTime tanggalPemesanan;
    String statusPesanan;

    Fields({
        required this.user,
        required this.namaPenerima,
        required this.alamatPengiriman,
        required this.tanggalPemesanan,
        required this.statusPesanan,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        namaPenerima: json["nama_penerima"],
        alamatPengiriman: json["alamat_pengiriman"],
        tanggalPemesanan: DateTime.parse(json["tanggal_pemesanan"]),
        statusPesanan: json["status_pesanan"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "nama_penerima": namaPenerima,
        "alamat_pengiriman": alamatPengiriman,
        "tanggal_pemesanan": "${tanggalPemesanan.year.toString().padLeft(4, '0')}-${tanggalPemesanan.month.toString().padLeft(2, '0')}-${tanggalPemesanan.day.toString().padLeft(2, '0')}",
        "status_pesanan": statusPesanan,
    };
}
