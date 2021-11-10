import 'dart:convert';

import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_studydesk/src/models/study_material.dart';

class TopicMaterialService{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";
  final UserPreferences _prefs = UserPreferences();

  Future<Map<String,dynamic>> getAllStudyMaterialsByTopicId(int topicId) async
  {
    Uri url = Uri.parse('$_dataUrl/api/topics/$topicId/materials');


    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json",
        'Authorization': 'Bearer ${_prefs.token}'},
    );

    final decodeResp = json.decode(resp.body);

    //final listItems = (decodeResp as List).map((i) => StudyMaterial.fromJson(i));


    //print(listItems);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'studyMaterials':decodeResp};
    }
    else{

      return {'ok':false,'studyMaterials':[]};
    }
  }

  Future<Map<String,dynamic>> postStudyMaterialByTopicId(int topicId,StudyMaterial model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/topics/$topicId/materials');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: studyMaterialToJson(model)
    );

    print(resp);

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('id')){
      return {'ok':true,'id':decodeResp['id']};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }
}