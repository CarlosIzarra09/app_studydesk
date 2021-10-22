import 'package:app_studydesk/src/services/auth_service.dart';
import 'package:app_studydesk/src/services/career_service.dart';
import 'package:app_studydesk/src/services/institute_service.dart';
import 'package:app_studydesk/src/services/user_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();
  final _userService = UserService();
  final _instituteService = InstituteService();
  final _careerService = CareerService();
  //final _userPreferences = UserPreferences();
  var _name = "";
  var _lastname = "";
  var _email = "";
  var _passw = "";
  int _currentStep = 0;
  Map<String, dynamic> _valueUniversity = {"id": 1, "name": "UPC"};
  Map<String, dynamic> _valueCareer = {"id": 1, "name": "Ingenieria"};
  List<dynamic> _universities = [];
  List<dynamic> _careers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Stepper(
          type: StepperType.horizontal,
          physics: const ClampingScrollPhysics(),
          steps: getSteps(),
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              if(_currentStep == 0){
                _currentStep++;
              }
              else{
                _signUpUser();
              }

            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep == 0) {
                Navigator.of(context).pop();
              } else {
                _currentStep--;
              }
            });
          },
          controlsBuilder: (context, {onStepCancel, onStepContinue}) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: onStepCancel,
                  child: const Text(
                    'REGRESAR',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: onStepContinue,
                  child: _currentStep == 0
                      ? const Text('CONTINUAR')
                      : const Text('FINALIZAR'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _makeBackground(BuildContext context) {
    return Column(
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
          width: double.infinity,
          margin: const EdgeInsets.only(top: 50),
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'REGÍSTRATE',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromRGBO(56, 72, 171, 1)),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: _currentStep == 0
                    ? _registerFirstForm(context)
                    : _registerSecondForm(context),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _registerFirstForm(BuildContext context) {
    return Column(
      children: <Widget>[
        _nameField(),
        const SizedBox(
          height: 20,
        ),
        _lastnameField(),
        const SizedBox(
          height: 20,
        ),
        _emailField(),
        const SizedBox(
          height: 20,
        ),
        _passwordField(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _registerSecondForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Universidad",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<Map<String, dynamic>>(
                  underline: const SizedBox(),
                  value: _valueUniversity,
                  isExpanded: true,
                  items: _universities
                      .map<DropdownMenuItem<Map<String, dynamic>>>((item) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: item,
                      child: Text(item['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      getCareers(value!['id']);
                      _valueUniversity = value;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Carrera",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<Map<String, dynamic>>(
                  underline: const SizedBox(),
                  value: _valueCareer,
                  isExpanded: true,
                  items: _careers
                      .map<DropdownMenuItem<Map<String, dynamic>>>((item) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: item,
                      child: Text(item['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valueCareer = value!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _nameField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.name,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            focusColor: Colors.white,
            hoverColor: Colors.white,
            fillColor: Color.fromRGBO(255, 255, 255, 0.25),
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Ingresa tus nombres',
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white60),
            labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
        ));
  }

  Widget _lastnameField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.name,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            focusColor: Colors.white,
            hoverColor: Colors.white,
            fillColor: Color.fromRGBO(255, 255, 255, 0.25),
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Ingresa tus apellidos',
            icon: Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white60),
            labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              _lastname = value;
            });
          },
        ));
  }

  Widget _emailField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
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
            icon: Icon(
              Icons.email,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white60),
            labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
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
            icon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white60),
            labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              _passw = value;
            });
          },
        ));
  }



  void _signUpUser() async {
    final dataUser ={
      "name": _name,
      "lastName": _lastname,
      "logo": "string",
      "email": _email,
      "password": _passw};

    final response = await _authService.signUpUser(dataUser, _valueCareer['id']);
    //print(response);
    if (response['ok']) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      _showAlert(context);
    }

    //Navigator.of(context).pushNamed('/home');
  }

  List<Step> getSteps() => [
        Step(
          isActive: _currentStep >= 0,
          title: Text('Cuenta'),
          content: _makeBackground(context),
        ),
        Step(
          isActive: _currentStep >= 1,
          title: Text('Informacion adicional'),
          content: _makeBackground(context),
        )
      ];

  void getUniversities() async {
    var univResponse = await _instituteService.getAllInstitutes();
    _universities = univResponse['institutes'];
    _valueUniversity = _universities[0];
    getCareers(_valueUniversity['id']);
  }

  void getCareers(int id) async {
    var careerResponse = await _careerService.getCareersByInstituteId(id);
    setState(() {
      if (careerResponse['ok']) {
        _careers = careerResponse['careers'];
        _valueCareer = _careers[0];
      } else {
        _careers = [
          {'id': -1, 'name': ""}
        ];
        _valueCareer = _careers[0];
      }
    });
  }
}

void _showAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al registrar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //const Text('El correo o contraseña ingresada es incorrecto.'),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Image(
                    image: AssetImage('assets/images/login_fail.png'),
                  ))
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Volver a intentar')),
          ],
        );
      });
}
