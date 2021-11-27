import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/services/platform_service.dart';
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

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  Text("Josias Olaya", style: TextStyle(color: Colors.grey[800], fontFamily: "Doris-P",
                                      fontSize: 36, fontWeight: FontWeight.w700
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
                                    Text("400 PE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
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
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              style: TextStyle(fontSize: 16),
                            ),

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
                            //for list of clients
                            Text("tutor@correo.com", style: TextStyle(fontSize: 18
                            ),),

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

  void _profileTutor(BuildContext context) async {
    var TutorResponse = await _tutorService.getUserTutor(1);
    final tutor = UserTutor.fromJson(TutorResponse["user"]);
    print(tutor);
  }
  
}