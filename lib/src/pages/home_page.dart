import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final UserPreferences _userPreferences = UserPreferences();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${_userPreferences.name}'),
      ),
      body: ListView(
        children: <Widget>[
          //_routeButtons(context),
          Container(
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


          _optionContainer(context,
              "assets/images/contacts_net.png",
              "SUBIR DOCUMENTOS",
              "Comparte tus documentos y apuntes",
              const Color.fromRGBO(111, 208, 253, 1),
              //manda tu ruta por aqui
              "/home"),
          _optionContainer(context,
              "assets/images/findsearch.png",
              "SISTEMA DE BÚSQUEDA",
              "Encuentra documentos de tu carrera universitaria y también tutores",
              Colors.white,
              "/finddocuments"),
          _optionContainer(context,
              "assets/images/students_pc.png",
              "CONVIERTETE EN TUTOR",
              "Comparte tus conocimientos y cobra por ello",
              const Color.fromRGBO(111, 208, 253, 1),
              "/home"),
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

                        //TODO: De esta manera me muevo a una ruta con nombre
                        Navigator.of(context).pushNamed(route);

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

 /* Widget _routeButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          child: const Text('ver documentos'),
          onPressed: () {
            // De esta manera me muevo a una ruta con nombre
            //Navigator.of(context).pushNamed('/home');
          },
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
          child: const Text('buscar documentos'),
          onPressed: () {
            //Navigator.of(context).pushNamed('/home');
          },
        ),
      ],
    );
  }*/
}
