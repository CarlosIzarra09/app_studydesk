import 'dart:convert';

Document documentsFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.topicId,
  });

  String title;
  String description;
  String fileUrl;
  int topicId;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    title: json["title"],
    description: json["description"],
    fileUrl: json["fileUrl"],
    topicId: json["topicId"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "fileUrl": fileUrl,
    "topicId": topicId,
  };
}