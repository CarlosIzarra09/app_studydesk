import 'dart:convert';

SessionStudent sessionStudentFromJson(String str) => SessionStudent.fromJson(json.decode(str));

String sessionStudentToJson(SessionStudent data) => json.encode(data.toJson());

class SessionStudent {
  SessionStudent({
    required this.qualification,
    required this.confirmed,
  });

  int qualification;
  bool confirmed;

  factory SessionStudent.fromJson(Map<String, dynamic> json) => SessionStudent(
    qualification: json["qualification"],
    confirmed: json["confirmed"],
  );

  Map<String, dynamic> toJson() => {
    "qualification": qualification,
    "confirmed": confirmed,
  };
}


