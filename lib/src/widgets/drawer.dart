import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

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
            accountName: Text(_prefs.name),
            accountEmail: Text(_prefs.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Text('SD'),
              foregroundImage: NetworkImage(_prefs.imageProfile)
            ),
          ),

          ListTile(
            leading: Icon(Icons.home),
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
              // Update the state of the app.
              // ...
            },
          ),

          ListTile(
            leading: Icon(Icons.description),
            title: const Text('Mis documentos'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),

          Expanded(child: SizedBox()),
          Divider(),
          ListTile(
            tileColor: Colors.white10,
            leading: Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _prefs.Name = "";
              _prefs.Email = "";
              _prefs.ImageProfile = "";
              _prefs.Id = 0;
              _prefs.Token ="";

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
