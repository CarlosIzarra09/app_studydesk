import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/services/auth_service.dart';
import 'package:app_studydesk/src/services/user_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _userService = UserService();
  final _userPreferences = UserPreferences();
  final _formKey = GlobalKey<FormState>();
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  late RegExp regex;

  var _email = "";
  var _passw = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regex = RegExp(pattern.toString());
    _initPreferences();
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        ));
  }

  Widget _passwordFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
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
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su contraseña';
            }
            return null;
          },
          onChanged: (value){
            setState(() {
              _passw = value;
            });
          },
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
      final response = await _authService.logginUser(Authenticate(email: _email, password: _passw));
      //print(response);
      if(response['ok']){
        await _userService.getUser(response['id']);
        Navigator.of(context).pushReplacementNamed('/home');
      }
      else{
        _showAlert(context);
      }

    }

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

