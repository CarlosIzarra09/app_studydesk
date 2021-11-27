import 'package:app_studydesk/src/models/user_student.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/util/dbhelper.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, this.userStudent, this.userTutor}) : super(key: key);
  final UserStudent? userStudent;
  final UserTutor? userTutor;

  @override
  Widget build(BuildContext context) {
    final _prefs = UserPreferences();

    return Drawer(
      child: Column(

        //padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0062ac),
            ),
            accountName: (_prefs.isTutor)? Text(userTutor!.name):Text(userStudent!.name),
            accountEmail: (_prefs.isTutor)? Text(userTutor!.email):Text(userStudent!.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Text('SD'),
              foregroundImage: (_prefs.isTutor)? NetworkImage(userTutor!.logo):NetworkImage(userStudent!.logo),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Principal'),
            onTap: () {
              // Update the state of the app.
              // ...

              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/home');

            },
          ),

          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Mi perfil'),
            onTap: () {
              Navigator.of(context).pop();
              if(_prefs.isTutor) {
                Navigator.of(context).pushNamed('/profile-tutor',arguments: userTutor);
              }
              // Update the state of the app.
              // ...
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Mis documentos'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),

          const Expanded(child: SizedBox()),
          const Divider(),
          ListTile(
            tileColor: Colors.white10,
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _prefs.Id = 0;
              _prefs.Token ="";
              (_prefs.isTutor)? DbHelper.myDatabase.deleteAllTutors():DbHelper.myDatabase.deleteAllStudents();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              // Update the state of the app.
              // ...
            },
          ),
        ],

      ),
    );
  }
}
