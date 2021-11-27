import 'dart:convert';

import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class SessionService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> postSessionByTutorId(Session model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/tutors/${_prefs.id}/sessions');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
        body: sessionToJson(model)
    );

    //print(resp.body);

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('id')){
      return {'ok':true};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }

  Future<Map<String,dynamic>> getSessionByTutorId(int tutorId) async{
    Uri url = Uri.parse('$_dataUrl/api/tutors/$tutorId/sessions');

    final resp = await http.get(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
    );


    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty){
      return {'ok':true,'sessions':decodeResp};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }
  }

  Future<Map<String,dynamic>> getSessionByStudentId(int studentId) async{
    Uri url = Uri.parse('$_dataUrl/api/students/$studentId/sessions');

    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer ${_prefs.token}'},
    );


    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty){
      return {'ok':true,'sessions':decodeResp};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }
  }

  Future<Map<String,dynamic>> putQualificationSession(int studentId, int sessionId,int value) async{
    Uri url = Uri.parse('$_dataUrl/api/students/$studentId/sessions/$sessionId');

    var bodyRequest = {
      'qualification':value,
      'confirmed':true,
    };

    final resp = await http.put(
      url,
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer ${_prefs.token}'},
      body: json.encode(bodyRequest)
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.containsKey('qualification')){
      return {'ok':true};
    }
    else{
      return {'ok':false};
    }
  }

  Future<Map<String,dynamic>> getQualificationSession(int studentId, int sessionId) async{
    Uri url = Uri.parse('$_dataUrl/api/students/$studentId/sessions/$sessionId');

    final resp = await http.get(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.containsKey('qualification')){
      return {'ok':true,'qualification':decodeResp['qualification']};
    }
    else{
      return {'ok':false};
    }
  }


  Future<Map<String,dynamic>> deleteSessionStudent(int studentId, int sessionId) async{
    Uri url = Uri.parse('$_dataUrl/api/students/$studentId/sessions/$sessionId');

    final resp = await http.delete(
      url,
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer ${_prefs.token}'},
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.containsKey('qualification')){
      return {'ok':true,'qualification':decodeResp['qualification']};
    }
    else{
      return {'ok':false};
    }
  }
}