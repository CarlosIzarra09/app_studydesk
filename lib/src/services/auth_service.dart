import 'dart:convert';
import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/models/user_student.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/services/user_student_service.dart';
import 'package:app_studydesk/src/services/user_tutor_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/util/dbhelper.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final _prefs = UserPreferences();
  final _userStudent = UserStudentService();
  final _userTutor = UserTutorService();
  final String _dataUrl = "https://studydeskapi.azurewebsites.net";

  Future<Map<String,dynamic>> loggingUser(Authenticate user) async
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
      _prefs.IsTutor = decodeResp['isTutor'];
      if(_prefs.isTutor){
        final user = await _userTutor.getUserTutor(_prefs.id);

        await DbHelper.myDatabase.insertTutor(UserTutor.fromJson(user['user']));
      }
      else{
        final user = await _userStudent.getUserStudent(_prefs.id);

        await DbHelper.myDatabase.insertStudent(UserStudent.fromJson(user['user']));
        //print(user);
      }


      /*_prefs.ImageProfile = user['user']['logo'];
      _prefs.Name = user['user']['name'];*/
      return {'ok':true,'id':decodeResp['id'],'token':decodeResp['token']};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'mensaje':decodeResp['message']};
    }
  }

  Future<Map<String,dynamic>> signUpUser(UserStudent dataUser,int careerId) async
  {
    Uri url = Uri.parse('$_dataUrl/api/careers/$careerId/students');


    final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: userStudentToJson(dataUser)
    );

    //print(resp.body);


    Map<String,dynamic> decodeResp = json.decode(resp.body);

    //print(decodeResp);
    if(decodeResp.containsKey('id'))
    {
      return {'ok':true};
    }
    else{
      //no guardo el usuario o ya existe
      return {'ok':false,'message':decodeResp};
    }
  }
}