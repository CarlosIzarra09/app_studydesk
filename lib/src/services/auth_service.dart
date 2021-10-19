import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final _prefs = UserPreferences();
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> logginUser(String email, String password) async
  {
    Uri url = Uri.parse('$_dataUrl/api/users/authenticate');
    final authData = {
      "email": email,
      "password":password,
    };


    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData)
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    //print(decodeResp);
    if(decodeResp.containsKey('token'))
    {
      //Guardar el token
      _prefs.Token = decodeResp['token'];
      return {'ok':true,'token':decodeResp['token']};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'mensaje':decodeResp['message']};
    }
  }
}