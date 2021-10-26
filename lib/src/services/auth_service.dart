import 'dart:convert';
import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/models/user.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final _prefs = UserPreferences();
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> logginUser(Authenticate user) async
  {
    Uri url = Uri.parse('$_dataUrl/api/users/authenticate');



    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: authenticateToJson(user),
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    //print(decodeResp);
    if(decodeResp.containsKey('token'))
    {
      //Guardar el token
      _prefs.Token = decodeResp['token'];
      return {'ok':true,'id':decodeResp['id'],'token':decodeResp['token']};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'mensaje':decodeResp['message']};
    }
  }

  Future<Map<String,dynamic>> signUpUser(User dataUser,int careerId) async
  {
    Uri url = Uri.parse('$_dataUrl/api/careers/$careerId/students');


    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: userToJson(dataUser)
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    //print(decodeResp);
    if(decodeResp.containsKey('id'))
    {
      //Guardar el token
      _prefs.Name = decodeResp['name'];
      return {'ok':true};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false};
    }
  }
}