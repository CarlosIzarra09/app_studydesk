import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> getAllCategories() async
  {
    Uri url = Uri.parse('$_dataUrl/api/categories');


    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer ${_prefs.token}'},
    );

    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'categories':decodeResp};
    }
    else{
      return {'ok':false,'categories':[]};
    }
  }
}