import 'package:app_studydesk/src/models/user_student.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/util/dbhelper.dart';
import 'package:app_studydesk/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final UserPreferences _prefs = UserPreferences();
  UserStudent? userStudent = UserStudent(name: "", lastName: "", logo: "", email: "", password: "", isTutor: 0);
  UserTutor? userTutor = UserTutor(name: "",courseId: 0 ,lastName: "", logo: "", description: "", pricePerHour: 0.0, email: "", password: "");

  @override
  void initState() {
    super.initState();
    _prefs.LastPage = "/home";
    getLoggedUser();
  }

  void getLoggedUser() async {

    (_prefs.isTutor)? userTutor = await DbHelper.myDatabase.getUserTutorByID(_prefs.id):
    userStudent = await DbHelper.myDatabase.getUserStudentByID(_prefs.id);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //title: (_prefs.isTutor)?Text("tutor"):Text("estudiante, ${userStudent!.name}"),
        title: (_prefs.isTutor)? Text('Bienvenido, tutor ${userTutor!.name}'):Text('Bienvenido, ${userStudent!.name}'),
      ),
      drawer: DrawerWidget(userStudent: userStudent,userTutor: userTutor,),
      body: ListView(
        children: <Widget>[
          //_routeButtons(context),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Image(image: AssetImage("assets/images/avatar.png"),
                  height: 120,
                ),
                SizedBox(width: 15,),
                Image(image: AssetImage("assets/texts/studydesk_title_logo.png"),
                width: 240,
                )
              ],
            ),
          ),

          (_prefs.isTutor)?
              Column(
                children: <Widget>[
                  _optionContainer(context,
                      "assets/images/calendar.png",
                      "Agendar sesión",
                      "Crea una sesión de tutoria, es rápido y sencillo",
                      const Color.fromRGBO(111, 208, 253, 1),
                      //manda tu ruta por aqui
                      "/detail-session"),
                  _optionContainer(context,
                      "assets/images/tutoria_virtual.png",
                      "Mis sesiones",
                      "Revisa tus sessiones pendientes e ingresa a ellas para comenzar a enseñar",
                      Colors.white,
                      //manda tu ruta por aqui
                      "/sessions"),
                  _optionContainer(context,
                      "assets/images/stars.png",
                      "Mis calificaciones",
                      "Revisa lo que tus estudiantes opinan de tus sesiones",
                      const Color.fromRGBO(111, 208, 253, 1),
                      //manda tu ruta por aqui
                      "/home"),
                ],):
              Column(
                children: <Widget>[
                  _optionContainer(context,
                      "assets/images/contacts_net.png",
                      "SUBIR DOCUMENTOS",
                      "Comparte tus documentos y apuntes",
                      const Color.fromRGBO(111, 208, 253, 1),
                      //manda tu ruta por aqui
                      "/upload"),
                  _optionContainer(context,
                      "assets/images/findsearch.png",
                      "SISTEMA DE BÚSQUEDA",
                      "Encuentra documentos de tu carrera universitaria y también tutores",
                      Colors.white,
                      "/download"),
                  _optionContainer(context,
                      "assets/images/students_pc.png",
                      "CONVIERTETE EN TUTOR",
                      "Comparte tus conocimientos y cobra por ello",
                      const Color.fromRGBO(111, 208, 253, 1),
                      "/home")
              ],)




        ],
      ),
    );
  }

  Widget _optionContainer(BuildContext context,
      String imgPath, String txtbutton, String description,
      Color myColor, String route) {
    return Container(
      //width: double.infinity,
      color: myColor,
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 180,
                width: 180,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image(
                  image: AssetImage(imgPath),

                ),
              )
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              const Expanded(child: SizedBox()),

              LimitedBox(
                maxWidth: 160,
                  child: Text(description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  )
              ),

              const Expanded(child: SizedBox()),
              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(56, 72, 171, 1)),
                      ),
                      onPressed: () {

                        if(_prefs.lastPage != route) {
                          if(route == "/detail-session") {
                            Navigator.of(context).pushNamed(
                                route, arguments: userTutor);
                          }
                          else{
                            Navigator.of(context).pushNamed(route);
                          }
                        }

                      },
                      child: Text(txtbutton,
                      )
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
