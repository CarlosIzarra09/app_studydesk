// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({
    this.id,
    required this.title,
    required this.logo,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.quantityMembers,
    required this.price,
    required this.categoryId,
    required this.platformId,
    required this.topicId,
  });

  int?id;
  String title;
  String logo;
  String description;
  DateTime startDate;
  DateTime endDate;
  int quantityMembers;
  double price;
  int categoryId;
  int platformId;
  int topicId;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id:json["id"],
    title: json["title"],
    logo: json["logo"],
    description: json["description"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    quantityMembers: json["quantityMembers"],
    price: json["price"].toDouble(),
    categoryId: json["categoryId"],
    platformId: json["platformId"],
    topicId: json["topicId"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "logo": logo,
    "description": description,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "quantityMembers": quantityMembers,
    "price": price,
    "categoryId": categoryId,
    "platformId": platformId,
    "topicId": topicId,
  };
}
