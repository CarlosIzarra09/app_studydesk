import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        child: const TextField(
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
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
        ));
  }

  Widget _passwordField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const TextField(
          obscureText: true,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
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
        ));
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
            onPressed: (){

              Navigator.of(context).pushNamed('/home');

            },
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
}
