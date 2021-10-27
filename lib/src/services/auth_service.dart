import 'dart:convert';
import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/models/user.dart';
import 'package:app_studydesk/src/services/user_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final _prefs = UserPreferences();
  final _user = UserService();
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
      _prefs.Id = decodeResp['id'];
      _prefs.Email = decodeResp['email'];
      final user = await _user.getUser(_prefs.id);
      _prefs.ImageProfile = user['user']['logo'];
      _prefs.Name = user['user']['name'];
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

    //print(resp.body);


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    //print(decodeResp);
    if(decodeResp.containsKey('id'))
    {
      //Guardar el token
      _prefs.Id = decodeResp['id'];
      _prefs.Name = decodeResp['name'];
      _prefs.Email = decodeResp['email'];
      _prefs.ImageProfile = decodeResp['logo'];
      return {'ok':true};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false};
    }
  }
}