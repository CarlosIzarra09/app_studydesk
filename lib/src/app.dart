
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/pages/add_detail_session_page.dart';
import 'package:app_studydesk/src/pages/add_session_page.dart';
import 'package:app_studydesk/src/pages/download_doc_page.dart';
import 'package:app_studydesk/src/pages/sessions_page.dart';
import 'package:app_studydesk/src/route_generator.dart';
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
      onGenerateRoute: RouteGenerator.generateRoute,

    );
  }


}
