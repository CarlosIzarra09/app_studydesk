import 'dart:convert';

import 'package:app_studydesk/src/models/student_material.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class StudentMaterialService
{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> postStudentMaterialByStudentId(int studentId,StudentMaterial model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/student/$studentId/materials');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
        body: studentMaterialToJson(model)
    );

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('student') && decodeResp.containsKey('studyMaterial')){
      return {'ok':true};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }
}