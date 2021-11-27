import 'package:app_studydesk/src/models/topic.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/services/platform_service.dart';
import 'package:app_studydesk/src/services/topic_service.dart';
import 'package:app_studydesk/src/services/user_tutor_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTutorPage extends StatefulWidget {
  const ProfileTutorPage({Key? key, required this.userTutor}) : super(key: key);
  final UserTutor userTutor;

  @override
  State<StatefulWidget> createState() => _ProfileTutorPage();
}

class _ProfileTutorPage extends State<ProfileTutorPage> {
  final _prefs = UserPreferences();
  final _tutorService = UserTutorService();
  final _topicService = TopicService();
  Topic _valueTopic = Topic(id: 0, name: "none");
  String carreraTutor = "";
  @override
  void initState() {
    _getCareerName(widget.userTutor.courseId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.network(widget.userTutor.logo, fit: BoxFit.cover,),
          ),

          DraggableScrollableSheet(
            minChildSize: 0.1,
            initialChildSize: 0.22,
            builder: (context, scrollController){
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //for user profile header
                      Container(
                        padding : EdgeInsets.only(left: 32, right: 32, top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: ClipOval(
                                  child: Image.network(widget.userTutor.logo, fit: BoxFit.cover,),
                                )
                            ),

                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${widget.userTutor.name} ${widget.userTutor.lastName}", style: TextStyle(color: Colors.grey[800], fontFamily: "Doris-P",
                                      fontSize: 30, fontWeight: FontWeight.w700
                                  ),),
                                ],
                              ),
                            ),
                            Icon(Icons.alternate_email, color: Colors.blue, size: 30,)
                          ],
                        ),
                      ),

                      SizedBox(height: 16,),
                      Container(
                        padding: EdgeInsets.all(32),
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 30,),
                                    SizedBox(width: 4,),
                                    Text("${widget.userTutor.pricePerHour} / Hora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                                        fontFamily: "Doris-P", fontSize: 24
                                    ),)
                                  ],
                                ),

                                Text("Precio", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,
                                    fontFamily: "Doris-P", fontSize: 15
                                ),)
                              ],
                            ),
                            Column(
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16,),

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text("Descripción", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                fontFamily: "Doris-P", fontSize: 18
                            ),),

                            SizedBox(height: 8,),
                            Center(
                              child: Text(widget.userTutor.description,
                              style: TextStyle(fontSize: 16),
                            ),)
                          ],
                        ),
                      ),

                      SizedBox(height: 54,),

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text("Correo", style: TextStyle(fontWeight: FontWeight.w700,
                                fontFamily: "Doris-P", fontSize: 22
                            ),),
                            SizedBox(height: 8,),
                            Center(
                              child: Text(widget.userTutor.email, style: TextStyle(fontSize: 18
                              ),),
                            ),
                          ],
                        ),
                      ),



                      SizedBox(height: 54,),

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text("Carrera", style: TextStyle(fontWeight: FontWeight.w700,
                                fontFamily: "Doris-P", fontSize: 22
                            ),),
                            SizedBox(height: 8,),
                            Center(
                              child: Text(carreraTutor, style: TextStyle(fontSize: 18
                              ),),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Widget _profile(BuildContext context) {
  //   return Lis
  // }

  void _getCareerName(int courseId) async {
    var topicResponse = await _topicService.getTopicByCourseId(courseId);
    if (topicResponse['ok']) {
      _valueTopic = (topicResponse['topics'] as List).map((e) => Topic.fromJson(e)).toList().first;
      carreraTutor = _valueTopic.course!.career!.name;
    } else {
      _valueTopic = [
        Topic(id: 0, name: "none")
      ].first;
    }
  }
}