import 'dart:async';

import 'package:app_studydesk/src/models/platform_session.dart';
import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/services/platform_service.dart';
import 'package:app_studydesk/src/services/session_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/widgets/start_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class StudentSessionsPage extends StatefulWidget {
  const StudentSessionsPage({Key? key}) : super(key: key);

  @override
  _StudentSessionsPageState createState() => _StudentSessionsPageState();
}

class _StudentSessionsPageState extends State<StudentSessionsPage> {
  final _sessionService = SessionService();
  final _prefs = UserPreferences();

  final _platformService = PlatformService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis sesiones"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getSessionsByStudentId(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Session>> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _listCardSessions(snapshot.data!),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "Cargando",
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(height: 40),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Session>> getSessionsByStudentId() async {
    var sessionResponse =
        await _sessionService.getSessionByStudentId(_prefs.id);
    //print(sessionResponse);
    var _sessions = (sessionResponse['sessions'] as List)
        .map((item) => Session.fromJson(item))
        .toList();

    await Future.forEach(_sessions, (element) async {});

    for (var item in _sessions) {
      item.qualification = await _getQualifySession(item.id!);
    }

    //_sessions.forEach((element) { })
    //const futures = _sessions.map((item) => _getQualifySession(item.id!));

    return _sessions;
  }

  Widget _listCardSessions(List<Session> sessions) {
    return ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (BuildContext context, int index) {
          int rating = sessions[index].qualification!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Card(
              elevation: 15,
              color: Colors.blueAccent,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image(
                                    image: NetworkImage(sessions[index].logo),
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _showPlatformUrl(
                                          sessions[index].platformId);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromRGBO(
                                                  220, 220, 220, 1)),
                                    ),
                                    child: const Text(
                                      "Ingresar ahora",
                                      style: TextStyle(color: Colors.blue),
                                    ))
                              ],
                            )),
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: <Widget>[
                              Text(
                                sessions[index].title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                sessions[index].description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Empieza el d??a:  ${sessions[index].startDate.toString()}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        StatefulBuilder(
                          builder: (context, setState) {
                            return StarRating(
                              filledStar: Icons.star,
                              unfilledStar: Icons.star_border,
                              onChanged: (value) {
                                if (sessions[index]
                                    .startDate
                                    .isBefore(DateTime.now())) {
                                  setState(() {
                                    rating = value;
                                    _putQualifySession(
                                        sessions[index].id!, rating);
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'No es posible calificar esta sesi??n'),
                                          content: SizedBox(
                                            width: 300,
                                            height: 150,
                                            child: Column(
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.info_outline,
                                                  size: 100,
                                                ),
                                                Text(
                                                  "Esta sesi??n a??n no ha concluido",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Close')),
                                          ],
                                        );
                                      });
                                }
                              },
                              value: rating,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Califica esta sesi??n",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: (){
                              _deleteReservation(sessions[index].id!);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                            child: Row(
                              children: const [
                                Icon(Icons.exit_to_app_outlined),
                                Text("Salir de la sesi??n")
                              ],
                            ) )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<int> _getQualifySession(int sessionId) async {
    var resp =
        await _sessionService.getQualificationSession(_prefs.id, sessionId);
    if (resp["ok"]) {
      return resp["qualification"];
    } else {
      return 0;
    }
  }

  void _putQualifySession(int sessionId, int rating) async {
    var resp = await _sessionService.putQualificationSession(
        _prefs.id, sessionId, rating);
    if (resp["ok"]) {
      print("Se actualiz?? la sesi??n ${sessionId} de student ${_prefs.id}");
    }
  }

  void _showPlatformUrl(int platformId) async {
    var platformResponse =
        await _platformService.getPlatformSession(platformId);
    if (platformResponse["ok"]) {
      final PlatformSession platform =
          PlatformSession.fromJson(platformResponse["platform"]);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Enlace a la sesi??n'),
              content: Text(
                platform.platformUrl,
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close')),
                TextButton(
                  onPressed: () {
                    _launchURL(platform.platformUrl);
                  },
                  child: const Text('Abrir en el navegador'),
                )
              ],
            );
          });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _deleteReservation(int sessionId) async{
    var resp = await _sessionService.deleteSessionStudent(_prefs.id, sessionId);
    if (resp["ok"]){
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content:
          Row(
              children: const <Widget>[
                Icon(Icons.exit_to_app,color: Colors.white,),
                SizedBox(width: 20),
                Text('Se elimin?? la reservaci??n de tutoria')
              ]
          )
      ));
    }

  }
}
