// To parse this JSON data, do
//
//     final zoomMeeting = zoomMeetingFromJson(jsonString);

import 'dart:convert';

ZoomMeeting zoomMeetingFromJson(String str) => ZoomMeeting.fromJson(json.decode(str));

String zoomMeetingToJson(ZoomMeeting data) => json.encode(data.toJson());

class ZoomMeeting {
  ZoomMeeting({
    this.topic,
    this.type,
    this.startTime,
    this.duration,
    this.scheduleFor,
    this.timezone,
    this.password,
    this.agenda,
  });

  String? topic;
  String? type;
  String? startTime;
  String? duration;
  String? scheduleFor;
  String? timezone;
  String? password;
  String? agenda;

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) => ZoomMeeting(
    topic: json["topic"],
    type: json["type"],
    startTime: json["start_time"],
    duration: json["duration"],
    scheduleFor: json["schedule_for"],
    timezone: json["timezone"],
    password: json["password"],
    agenda: json["agenda"],
  );

  Map<String, dynamic> toJson() => {
    "topic": topic,
    "type": type,
    "start_time": startTime,
    "duration": duration,
    "schedule_for": scheduleFor,
    "timezone": timezone,
    "password": password,
    "agenda": agenda,
  };
}

