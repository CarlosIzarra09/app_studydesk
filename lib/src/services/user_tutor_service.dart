import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserTutorService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> getUserTutor(int id) async
  {
    Uri url = Uri.parse('$_dataUrl/api/tutors/$id');


    final resp = await http.get(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('name'))
    {

      return {'ok':true,'user':decodeResp};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'message':decodeResp};
    }
  }
}