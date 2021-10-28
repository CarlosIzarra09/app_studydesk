import 'dart:convert';
import 'package:http/http.dart' as http;

class TopicService {
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> getTopicByCourseId(int courseId) async
  {
    Uri url = Uri.parse('$_dataUrl/api/courses/$courseId/topics');


    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'topics':decodeResp};
    }
    else{
      return {'ok':false,'topics':[]};
    }
  }
}