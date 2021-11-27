
import 'package:app_studydesk/src/route_generator.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


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
