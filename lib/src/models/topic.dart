import 'dart:convert';

Topic topicFromJson(String str) => Topic.fromJson(json.decode(str));

String topicToJson(Topic data) => json.encode(data.toJson());

class Topic {
  Topic({
    required this.id,
    required this.name,
    this.course,
  });

  int id;
  String name;
  TCourse? course;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    name: json["name"],
    course: TCourse.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "course": course!.toJson(),
  };
}

class TCourse {
  TCourse({
    required this.id,
    required this.name,
    this.career,
  });

  int id;
  String name;
  TCareer? career;

  factory TCourse.fromJson(Map<String, dynamic> json) => TCourse(
    id: json["id"],
    name: json["name"],
    career: TCareer.fromJson(json["career"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "career": career!.toJson(),
  };
}

class TCareer {
  TCareer({
    required this.id,
    required this.name,
    this.university,
  });

  int id;
  String name;
  dynamic university;

  factory TCareer.fromJson(Map<String, dynamic> json) => TCareer(
    id: json["id"],
    name: json["name"],
    university: json["university"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "university": university,
  };
}