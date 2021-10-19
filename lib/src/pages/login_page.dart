import 'package:app_studydesk/src/services/auth_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _userPreferences = UserPreferences();
  var _email = "";
  var _passw = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPreferences();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _makeBackground(context),
          _loginForm(context),
          _buttonsOptions(context)
        ],
      ),
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
          height: 460,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('INICIAR SESION',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(56, 72, 171, 1)
                  ),

                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 150,)),
          SizedBox(height: 250,),
          _emailField(),
          SizedBox(height: 20,),
          _passwordField(),
        ],
      ),

    );
  }

  Widget _emailField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardType:  TextInputType.emailAddress,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              focusColor: Colors.white,
              hoverColor: Colors.white,
              fillColor: Color.fromRGBO(255, 255, 255, 0.25),
              filled: true,
              border: OutlineInputBorder(),
              hintText: 'user@email.com',
              labelText: 'Ingresa tu correo',
              icon: Icon(Icons.email,color: Colors.white,),
              hintStyle: TextStyle(color: Colors.white60),
              labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value){
            setState(() {
              _email = value;
            });
          },
        ));
  }

  Widget _passwordField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          obscureText: true,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            focusColor: Colors.white,
            hoverColor: Colors.white,
            fillColor: Color.fromRGBO(255, 255, 255, 0.25),
            filled: true,
            border: OutlineInputBorder(),
            hintText: 'Password123',
            labelText: 'Ingresa tu contraseña',
            icon: Icon(Icons.lock,color: Colors.white,),
            hintStyle: TextStyle(color: Colors.white60),
            labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value){
            setState(() {
              _passw = value;
            });
          },
        )
    );
  }

  Widget _buttonsOptions(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 580),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _authenticateUser,
            child: const Text('INGRESAR'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(56, 72, 171, 1)
                ),
            ),
          ),
          const SizedBox(height: 10,),
          const Text('¿No tienes una cuenta aún?',
          style: TextStyle(color: Colors.white,fontSize: 18),),
          const SizedBox(height: 50,),
          ElevatedButton(
            onPressed: (){},
            child: const Text('CREAR UNA CUENTA'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _authenticateUser() async{


    final response = await _authService.logginUser(_email, _passw);
    //print(response);
    if(response['ok']){
      Navigator.of(context).pushReplacementNamed('/home');
    }
    else{
      _showAlert(context);
    }

      //Navigator.of(context).pushNamed('/home');


  }

  void _initPreferences() async {
    await _userPreferences.initPrefs();
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
            TextButton(
                onPressed: () {

                },
                child: const Text('Olvidé mi contraseña'))
          ],
        );
      }
  );
}

