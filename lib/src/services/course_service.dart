import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String, dynamic>> getCoursesByCareerId(int careerId) async {
    Uri url = Uri.parse('$_dataUrl/api/career/$careerId/courses');

    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.isNotEmpty)
    {
      return {'ok':true,'courses':decodeResp};
    }
    else{
      return {'ok':false,'courses':[]};
    }
  }
}