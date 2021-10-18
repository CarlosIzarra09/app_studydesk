import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudydeskApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        //Aqui agregan sus rutas

        '/login':(BuildContext context)=>const LoginPage(),
        '/home':(BuildContext context)=>const HomePage(),
      },
    );
  }
}
