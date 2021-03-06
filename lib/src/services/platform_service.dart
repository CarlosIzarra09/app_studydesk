import 'dart:convert';

import 'package:app_studydesk/src/models/platform_session.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class PlatformService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> postPlatformSession(PlatformSession model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/platforms');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
        body: platformToJson(model)
    );

    //print(resp.body);

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('id')){
      return {'ok':true,'id':decodeResp['id']};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }

  Future<Map<String,dynamic>> getPlatformSession(int platformId) async {
    Uri url = Uri.parse('$_dataUrl/api/platforms/$platformId');
    final resp = await http.get(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer ${_prefs.token}'},
    );

    //print(resp.body);

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('id')){
      return {'ok':true,'platform':decodeResp};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }
  }
}