
import 'package:app_studydesk/src/pages/download_page.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/upload_documents.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studydesk App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        //Aqui agregan sus rutas

        '/login':(BuildContext context)=>const LoginPage(),
        '/register':(BuildContext context)=>const RegisterPage(),
        '/home':(BuildContext context)=>const HomePage(),
        '/upload': (BuildContext context) => const UploadDocumentsPage(),
        '/download': (BuildContext context) => const DownloadPage(),
      },
    );
  }
}
