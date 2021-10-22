import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;



class InstituteService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> getAllInstitutes() async
  {
    Uri url = Uri.parse('$_dataUrl/api/institutes');


    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'institutes':decodeResp};
    }
    else{

      return {'ok':false,'institutes':[]};
    }
  }
}