import 'package:app_studydesk/src/models/platform_session.dart';
import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/models/user_student.dart';
import 'package:app_studydesk/src/services/platform_service.dart';
import 'package:app_studydesk/src/services/session_service.dart';
import 'package:app_studydesk/src/services/user_student_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({Key? key, this.tutorId}) : super(key: key);
  final int? tutorId;

  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final _sessionService = SessionService();
  final _prefs = UserPreferences();

  final _platformService = PlatformService();
  final _studentService = UserStudentService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sesiones del tutor"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Text(
              "Sesiones disponibles",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Doris-P", fontSize: 30),
            ),
            Expanded(
              child: FutureBuilder(
                future: getSessionsByTutorId(),
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

  Future<List<Session>> getSessionsByTutorId() async {
    if (widget.tutorId != null) {
      var sessionResponse =
          await _sessionService.getSessionByTutorId(widget.tutorId!);
      //print(sessionResponse);
      var _sessions = (sessionResponse['sessions'] as List)
          .map((item) => Session.fromJson(item))
          .toList();
      return _sessions;
    } else {
      var sessionResponse =
          await _sessionService.getSessionByTutorId(_prefs.id);
      //print(sessionResponse);
      var _sessions = (sessionResponse['sessions'] as List)
          .map((item) => Session.fromJson(item))
          .toList();
      return _sessions;
    }
  }

  Widget _listCardSessions(List<Session> sessions) {
    return ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (BuildContext context, int index) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              _showStudentsOfSession(sessions[index].id!);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.indigo),
                            ),
                            child: Row(
                              children: const <Widget>[
                                Text(
                                  "Subir Material",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.upload_rounded)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              _showStudentsOfSession(sessions[index].id!);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(220, 220, 220, 1)),
                            ),
                            child: Text(
                              "Vacantes totales: ${sessions[index].quantityMembers}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
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

  void _showStudentsOfSession(int id) async {
    var studentsResponse = await _studentService.getStudentsBySessionId(id);
    final students = (studentsResponse['students'] as List)
        .map((item) => UserStudent.fromJson(item))
        .toList();

    if (studentsResponse["ok"]) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Lista de integrantes'),
              content: SizedBox(
                height: 300,
                width: 300,
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(students[index].logo),
                          ),
                          subtitle: Text(students[index].email),
                          trailing: const Icon(Icons.email),
                          title: Text(students[index].name),
                        ),
                        const Divider(),
                      ],
                    );
                  },
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
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Lista de integrantes'),
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
                      "Todavia ning??n estudiante ha reservado esta sesi??n",
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
  }
}
