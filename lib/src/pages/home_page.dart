import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final String user_name = 'Josias';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $user_name'),
      ),
      body: ListView(
        children: <Widget>[
          _routeButtons(context),
        ],
      ),
    );
  }

  Widget _routeButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          child: const Text('ver documentos'),
          onPressed: (){
            //TODO: De esta manera me muevo a una ruta con nombre
            //Navigator.of(context).pushNamed('/home');
          }, ),

        const Expanded(child: SizedBox()),

        ElevatedButton(
          child: const Text('buscar documentos'),
          onPressed: (){
            //Navigator.of(context).pushNamed('/home');

          }, ),
      ],
    );
  }
}
