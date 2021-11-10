import 'dart:convert';

University universityFromJson(String str) => University.fromJson(json.decode(str));

String universityToJson(University data) => json.encode(data.toJson());

class University {
  University({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory University.fromJson(Map<String, dynamic> json) => University(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}