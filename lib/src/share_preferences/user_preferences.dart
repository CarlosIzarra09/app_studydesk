import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static final UserPreferences _instance = UserPreferences._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _preferences;

  initPrefs() async{
    _preferences = await _prefs;
  }

  get token{
    return _preferences.getString('token');
  }

  set Token(String value) {
    _preferences.setString('token', value);
  }

  get id{
    return _preferences.getInt('id');
  }

  set Id(int value) {
    _preferences.setInt('id', value);
  }

  get name{
    return _preferences.getString('name');
  }

  set Name(String value) {
    _preferences.setString('name', value);
  }

  get email{
    return _preferences.getString('email');
  }

  set Email(String value) {
    _preferences.setString('email', value);
  }

  get imageProfile{
    return _preferences.getString('image');
  }

  set ImageProfile(String value) {
    _preferences.setString('image', value);
  }




  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._internal();


}