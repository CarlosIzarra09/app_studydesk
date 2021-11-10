import 'dart:convert';

Topic topicFromJson(String str) => Topic.fromJson(json.decode(str));

String topicToJson(Topic data) => json.encode(data.toJson());

class Topic {
  Topic({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}