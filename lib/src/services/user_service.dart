import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserService{
  final _prefs = UserPreferences();
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> getUser(int id) async
  {
    Uri url = Uri.parse('$_dataUrl/api/students/$id');


    final resp = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('name'))
    {
      //Guardar su nombre xd, es que aun no nos enseña sqlLite
      //y la libreria que conozco talvez sea diferente

      _prefs.Name = decodeResp['name'];
      return {'ok':true,'name':decodeResp['name']};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'mensaje':decodeResp};
    }
  }
}