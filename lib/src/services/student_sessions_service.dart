import 'dart:convert';

import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/models/session_student.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class StudentSessionService {
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String, dynamic>> postStudentSessionByTutorId(int studentId, int sessionId, SessionStudent model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/students/${studentId}/sessions/${sessionId}');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
        body: sessionStudentToJson(model)
    );

    //print(resp.body);

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('id')) {
      return {'ok': true};
    }
    else {
      return {'ok': false, 'message': decodeResp};
    }
  }
}