import 'dart:convert';

import 'package:app_studydesk/src/models/student_material.dart';
import 'package:http/http.dart' as http;

class StudentMaterialService
{
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> postStudentMaterialByStudentId(int studentId,StudentMaterial model) async
  {
    Uri url = Uri.parse('$_dataUrl/api/student/$studentId/materials');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: documentToJson(model)
    );

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('student') && decodeResp.containsKey('studyMaterial')){
      return {'ok':true};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }
}