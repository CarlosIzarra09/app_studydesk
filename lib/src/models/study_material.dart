import 'dart:convert';

StudyMaterial studyMaterialFromJson(String str) => StudyMaterial.fromJson(json.decode(str));

String studyMaterialToJson(StudyMaterial data) => json.encode(data.toJson());

class StudyMaterial {
  StudyMaterial({
    required this.title,
    required this.description,
    required this.fileName,
    required this.filePath,
    required this.size,
  });

  String title;
  String description;
  String fileName;
  String filePath;
  double size;

  factory StudyMaterial.fromJson(Map<String, dynamic> json) => StudyMaterial(
    title: json["title"],
    description: json["description"],
    fileName: json["fileName"],
    filePath: json["filePath"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "fileName": fileName,
    "filePath": filePath,
    "size": size
  };
}