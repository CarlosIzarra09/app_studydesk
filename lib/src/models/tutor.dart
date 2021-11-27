import 'dart:convert';

Tutor tutorFromJson(String str) => Tutor.fromJson(json.decode(str));

String tutorToJson(Tutor data) => json.encode(data.toJson());

class Tutor {
  Tutor({
    required this.id,
    required this.courseId,
    required this.name,
    required this.lastName,
    required this.description,
    required this.logo,
    required this.email,
    required this.password,
    required this.pricePerHour,
  });

  int id;
  int courseId;
  String name;
  String lastName;
  String description;
  String logo;
  String email;
  String password;
  int pricePerHour;

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
    id: json["id"],
    courseId: json["courseId"],
    name: json["name"],
    lastName: json["lastName"],
    description: json["description"],
    logo: json["logo"],
    email: json["email"],
    password: json["password"],
    pricePerHour: json["pricePerHour"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "courseId": courseId,
    "name": name,
    "lastName": lastName,
    "description": description,
    "logo": logo,
    "email": email,
    "password": password,
    "pricePerHour": pricePerHour,
  };
}