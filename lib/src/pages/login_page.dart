import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/services/auth_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/util/dbhelper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _prefs = UserPreferences();
  final _formKey = GlobalKey<FormState>();

  late RegExp regex;

  var _email = "";
  var _password = "";
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";

    regex = RegExp(pattern.toString());
    //_initPreferences();
    _prefs.LastPage = "/login";
    _initDatabase();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*body: Stack(
          children: <Widget>[
            _makeBackground(context),
            ListView(
              children: [
                _loginForm(context),
                _buttonsOptions(context)
              ],
            )

          ],
        ),*/
      body: _makeBackground(context),
    );
  }

  Widget _makeBackground(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Image(
            image: AssetImage('assets/images/avatar.png'),
            height: 150,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Image(
            image: AssetImage('assets/texts/studydesk_title_logo.png'),
            height: 70,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          color: Colors.lightBlueAccent,
          //height: 800,
          //height: 460,
          child: Column(
            children:  <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('INICIAR SESION',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(56, 72, 171, 1)
                  ),

                ),
              ),
              _loginForm(context),
              _buttonsOptions(context)
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40,),
          _emailFormField(),
          const SizedBox(height: 20,),
          _passwordFormField(),
        ],
      ) ,
    );
  }

  Widget _emailFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          keyboardType:  TextInputType.emailAddress,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          maxLength: 40,
          decoration: InputDecoration(
              counterText: "${_email.length.toString()}/40",
              counterStyle: const TextStyle(color: Colors.white),
              focusColor: Colors.white,
              hoverColor: Colors.white,
              fillColor: const Color.fromRGBO(255, 255, 255, 0.25),
              filled: true,
              border: const OutlineInputBorder(),
              hintText: 'user@email.com',
              labelText: 'Ingresa tu correo',
              icon: const Icon(Icons.email,color: Colors.white,),
              hintStyle: const TextStyle(color: Colors.white60),
              labelStyle: const TextStyle(color: Colors.white),
          ),
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su correo';
            }
            else{
              if(!regex.hasMatch(value)) {
                return "Por favor ingrese un email valido";
              }
            }

            return null;
          },
          onChanged: (value){
            setState(() {
              _email = value;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ));
  }

  Widget _passwordFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          obscureText: !_passwordVisible,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          maxLength: 15,
          decoration: InputDecoration(
            counterText: "${_password.length.toString()}/15",
            counterStyle: const TextStyle(color: Colors.white),
            focusColor: Colors.white,
            hoverColor: Colors.white,
            fillColor: const Color.fromRGBO(255, 255, 255, 0.25),
            filled: true,
            border: const OutlineInputBorder(),
            hintText: 'Password123',
            labelText: 'Ingresa tu contraseña',
            icon: const Icon(Icons.lock,color: Colors.white,),
            hintStyle: const TextStyle(color: Colors.white60),
            labelStyle: const TextStyle(color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su contraseña';
            }
            return null;
          },
          onChanged: (value){
            setState(() {
              _password = value;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
    );
  }

  Widget _buttonsOptions(BuildContext context){
    //final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _authenticateUser,
              child: (_isLoading)? const SizedBox(
                width: 20,height: 20,
                child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3),
              ): const Text('INGRESAR'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(56, 72, 171, 1)
                  ),
              ),
            ),
            const SizedBox(height: 10,),
            const Text('¿No tienes una cuenta aún?',
            style: TextStyle(color: Colors.white,fontSize: 18),),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){

                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('CREAR UNA CUENTA'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red
                ),
              ),
            ),
            const SizedBox(height: 40,),
          ],
        ),
    );
  }

  void _authenticateUser() async{


    if(_formKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      final response = await _authService.loggingUser(Authenticate(email: _email, password: _password));
      //print(response);
      if(response['ok']){
        //await _userService.getUser(response['id']);
        Navigator.of(context).pushReplacementNamed('/home');
      }
      else{
        setState(() {});
        _isLoading = false;
        _showAlert(context);
      }

    }

  }

  /*void _initPreferences() async {
    await _userPreferences.initPrefs();
  }*/

  void _initDatabase() async{
    await DbHelper.myDatabase.database;
  }
}

void _showAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al iniciar sesión'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('El correo o contraseña ingresada es incorrecto.'),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Image(
                    image: AssetImage('assets/images/login_fail.png'),
                  )
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok')),
            /*TextButton(
                onPressed: () {

                },
                child: const Text('Olvidé mi contraseña'))*/
          ],
        );
      }
  );
}

