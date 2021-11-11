import 'dart:convert';

UserTutor userTutorFromJson(String str) => UserTutor.fromJson(json.decode(str));

String userTutorToJson(UserTutor data) => json.encode(data.toJson());

class UserTutor {
  UserTutor({
    this.id,
    required this.courseId,
    required this.name,
    required this.lastName,
    required this.logo,
    required this.description,
    required this.pricePerHour,
    required this.email,
    required this.password,
  });

  int? id;
  int courseId;
  String name;
  String lastName;
  String description;
  double pricePerHour;
  String logo;
  String email;
  String password;

  factory UserTutor.fromJson(Map<String, dynamic> json) => UserTutor(
    id: json["id"],
    courseId: json["courseId"],
    name: json["name"],
    lastName: json["lastName"],
    logo: json["logo"],
    description: json["description"],
    pricePerHour: json["pricePerHour"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "courseId":courseId,
    "name": name,
    "lastName": lastName,
    "logo": logo,
    "description":description,
    "pricePerHour":pricePerHour,
    "email": email,
    "password": password,
  };

  factory UserTutor.fromDatabaseJson(Map<String, dynamic> json) => UserTutor(
      id: json["id"],
      courseId: json["courseId"],
      name: json["name"],
      lastName: json["lastName"],
      logo: json["logo"],
      email: json["email"],
      password: "unknown",
      description: json["description"],
      pricePerHour: json["pricePerHour"]
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "courseId":courseId,
    "name": name,
    "lastName": lastName,
    "logo": logo,
    "email": email,
    "description":description,
    "pricePerHour":pricePerHour,
  };
}
