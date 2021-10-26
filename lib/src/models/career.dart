import 'dart:convert';

import 'institute.dart';

Career careerFromJson(String str) => Career.fromJson(json.decode(str));

String careerToJson(Career data) => json.encode(data.toJson());

class Career {
  Career({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Career.fromJson(Map<String, dynamic> json) => Career(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}



