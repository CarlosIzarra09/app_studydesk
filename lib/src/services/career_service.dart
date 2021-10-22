import 'dart:convert';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;



class CareerService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> getCareersByInstituteId(int instituteId) async
  {
    Uri url = Uri.parse('$_dataUrl/api/institutes/$instituteId/careers');


    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'careers':decodeResp};
    }
    else{
      return {'ok':false,'careers':[]};
    }
  }
}