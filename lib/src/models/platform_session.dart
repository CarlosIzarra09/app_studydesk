import 'dart:convert';

PlatformSession platformFromJson(String str) => PlatformSession.fromJson(json.decode(str));

String platformToJson(PlatformSession data) => json.encode(data.toJson());

class PlatformSession {
  PlatformSession({
    this.id,
    required this.name,
    required this.platformUrl,
  });

  int? id;
  String name;
  String platformUrl;

  factory PlatformSession.fromJson(Map<String, dynamic> json) => PlatformSession(
    id: json["id"],
    name: json["name"],
    platformUrl: json["platformUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "platformUrl":platformUrl
  };
}