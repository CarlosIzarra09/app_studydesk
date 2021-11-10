import 'package:app_studydesk/src/app.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _prefs = UserPreferences();
  await _prefs.initPrefs();
  runApp(const MyApp());
}


