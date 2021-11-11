
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/pages/add_detail_session_page.dart';
import 'package:app_studydesk/src/pages/add_session_page.dart';
import 'package:app_studydesk/src/pages/download_doc_page.dart';
import 'package:app_studydesk/src/pages/sessions_page.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/upload_doc_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _prefs = UserPreferences();

    return MaterialApp(
      title: 'Studydesk App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en','US'),
        Locale('es','ES')
      ],


      initialRoute: _prefs.lastPage,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder:(BuildContext context) {
              switch (settings.name){
                case '/login':return const LoginPage();
                case '/register':return const RegisterPage();
                case '/home':return const HomePage();
                case '/upload': return const UploadDocumentsPage();
                case '/download': return const DownloadPage();
                case '/add-session':
                  final Map parameters = (settings.arguments as Map);
                  return AddSessionPage(parametersSession: parameters,);
                case '/detail-session':
                  final UserTutor tutor = (settings.arguments as UserTutor);
                  return AddDetailSessionPage(userTutor: tutor,);
                case '/sessions':return const SessionsPage();
                default: {
                  return const HomePage();
                }
              }
            }
        );
      },
      /*routes: {
        '/login':(BuildContext context)=>const LoginPage(),
        '/register':(BuildContext context)=>const RegisterPage(),
        '/home':(BuildContext context)=>const HomePage(),
        '/upload': (BuildContext context) => const UploadDocumentsPage(),
        '/download': (BuildContext context) => const DownloadPage(),
        '/add-session':(BuildContext context) => const AddSessionPage(),
        '/detail-session':(BuildContext context) => const AddDetailSessionPage(),
        '/sessions':(BuildContext context) => const SessionsPage(),
      },*/
    );
  }
}
