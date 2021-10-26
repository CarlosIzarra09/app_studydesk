import 'dart:convert';

Institute instituteFromJson(String str) => Institute.fromJson(json.decode(str));

String instituteToJson(Institute data) => json.encode(data.toJson());

class Institute {
  Institute({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}