import 'dart:convert';

UserStudent userStudentFromJson(String str) => UserStudent.fromJson(json.decode(str));

String userStudentToJson(UserStudent data) => json.encode(data.toJson());

class UserStudent {
  UserStudent({
    this.id,
    required this.name,
    required this.lastName,
    required this.logo,
    required this.email,
    required this.password,
    required this.isTutor
  });

  int? id;
  String name;
  String lastName;
  String logo;
  String email;
  String password;
  int isTutor;

  factory UserStudent.fromJson(Map<String, dynamic> json) => UserStudent(
    id: json["id"],
    name: json["name"],
    lastName: json["lastName"],
    logo: json["logo"],
    email: json["email"],
    password: json["password"],
    isTutor: (json["isTutor"])? 1:0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastName": lastName,
    "logo": logo,
    "email": email,
    "password": password,
    "isTutor":(isTutor== 0)?false:true
  };

  factory UserStudent.fromDatabaseJson(Map<String, dynamic> json) => UserStudent(
    id: json["id"],
    name: json["name"],
    lastName: json["lastName"],
    logo: json["logo"],
    email: json["email"],
    password: "unknown",
    isTutor: json["isTutor"]
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "name": name,
    "lastName": lastName,
    "logo": logo,
    "email": email,
    "isTutor":isTutor
  };
}
