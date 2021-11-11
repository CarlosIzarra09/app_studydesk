import 'dart:convert';

import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/models/zoom_meeting.dart';
import 'package:http/http.dart' as http;

class ZoomService{
  final String _dataUrl = "https://api.zoom.us/v2/users";

  Future<Map<String,dynamic>> requestRoom(ZoomMeeting model) async
  {
    Uri url = Uri.parse('$_dataUrl/me/meetings');

    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6Im1EcURjWHhRU3pPTjlhRm5DM0F0Z0EiLCJleHAiOjE2MzcyMTc4ODMsImlhdCI6MTYzNjYxMzA4MX0.F81z526FG7izXdgVyVLtUry8y6DXc9vJRGFcTCN2RY8'},
        body: zoomMeetingToJson(model),
    );

    //print(resp.body);

    Map<String,dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('host_id')){
      return {'ok':true,"urlMeet":decodeResp["join_url"]};
    }
    else{
      return {'ok':false,'message':decodeResp};
    }

  }
}