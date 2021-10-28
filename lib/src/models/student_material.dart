import 'dart:convert';

StudentMaterial documentFromJson(String str) => StudentMaterial.fromJson(json.decode(str));

String documentToJson(StudentMaterial data) => json.encode(data.toJson());

class StudentMaterial {
  StudentMaterial({
    required this.studyMaterialId,
  });


  int studyMaterialId;

  factory StudentMaterial.fromJson(Map<String, dynamic> json) => StudentMaterial(
    studyMaterialId: json["studyMaterialId"],
  );

  Map<String, dynamic> toJson() => {
    "studyMaterialId": studyMaterialId,
  };
}