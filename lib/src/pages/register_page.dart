import 'dart:io';

import 'package:app_studydesk/src/models/authenticate.dart';
import 'package:app_studydesk/src/models/career.dart';
import 'package:app_studydesk/src/models/institute.dart';
import 'package:app_studydesk/src/models/user.dart';
import 'package:app_studydesk/src/services/auth_service.dart';
import 'package:app_studydesk/src/services/career_service.dart';
import 'package:app_studydesk/src/services/cloudinary_service.dart';
import 'package:app_studydesk/src/services/institute_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();
  final _instituteService = InstituteService();
  final _careerService = CareerService();
  final _cloudService = CloudinaryService();
  
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _lastnameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwCtrl = TextEditingController();

  int _currentStep = 0;
  File? photo;

  Institute _valueUniversity = Institute(id: 0, name: "none");
  Career _valueCareer = Career(id: 0, name: "none");

  List<Institute> _universities = [];
  List<Career> _careers = [];
  bool _isLoadingValues = false;

  final _formKeyAccount = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  late RegExp regex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regex = RegExp(pattern.toString());
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
                if(_formKeyAccount.currentState!.validate()) {
                  _currentStep++;
                }
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
                  onPressed: (_valueCareer.name != "" && _isLoadingValues ==false)?onStepContinue:null,
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
        /*Container(
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
        ),*/
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
                margin: const EdgeInsets.only(top: 30),
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
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKeyAccount,
      child: Column(
        children: <Widget>[
          _nameFormField(),
          const SizedBox(
            height: 20,
          ),
          _lastnameFormField(),
          const SizedBox(
            height: 20,
          ),
          _emailFormField(),
          const SizedBox(
            height: 20,
          ),
          _passwordFormField(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _registerSecondForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(
                child: Card(
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (photo == null) ? const Image(
                    image: AssetImage("assets/images/placeholder_account.jpg"),
                    fit: BoxFit.cover,
                    height: 250,
                    width: 250,
                  ):Image.file(
                    photo!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200,left: 150),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      primary: Colors.blue, // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                    child: const Icon(Icons.photo_camera,size: 30,),
                    onPressed: _selectImage,
                  ),
                ),
              )

            ],
          ),

          const SizedBox(
            height: 20,
          ),
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
                child: DropdownButton<Institute>(
                  borderRadius: BorderRadius.circular(5),
                  menuMaxHeight: 550,
                  underline: const SizedBox(),
                  value: _valueUniversity,
                  isExpanded: true,
                  items: _universities
                      .map<DropdownMenuItem<Institute>>((item) {
                    return DropdownMenuItem<Institute>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valueUniversity = value!;
                      _isLoadingValues = true;
                      getCareers(value.id);
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
                child: DropdownButton<Career>(
                  menuMaxHeight: 600,
                  disabledHint: Text(_valueCareer.name),
                  borderRadius: BorderRadius.circular(5),
                  underline: const SizedBox(),
                  value: _valueCareer,
                  isExpanded: true,
                  items: _careers
                      .map<DropdownMenuItem<Career>>((item) {
                    return DropdownMenuItem<Career>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (_isLoadingValues || _valueCareer.name=="")? null :(value) {
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

  Widget _nameFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _nameCtrl,
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
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su nombre';
            }
            return null;
          },

        )
    );
  }

  Widget _lastnameFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _lastnameCtrl,
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
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese sus Apellidos';
            }
            return null;
          },

        ));
  }

  Widget _emailFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _emailCtrl,
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


        ));
  }

  Widget _passwordFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _passwCtrl,
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
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese su contraseña';
            }
            return null;
          },

        ));
  }



  void _signUpUser() async {

    String urlImage ="https://i1.wp.com/umram.bilkent.edu.tr/wp-content/uploads/2021/03/person.png";
    Map value ={};

    if(photo != null) {
      value = await _cloudService.uploadImage(photo!);
      urlImage = value['secure_url'];
    }


    final User dataUser = User(
        name: _nameCtrl.text, 
        lastName: _lastnameCtrl.text, 
        logo: urlImage,
        email: _emailCtrl.text, 
        password: _passwCtrl.text);
    

    final response = await _authService.signUpUser(dataUser, _valueCareer.id);
    //print(response);
    if (response['ok']) {

      final Authenticate authenticate = Authenticate(
          email: _emailCtrl.text,
          password: _passwCtrl.text);

      //guardamos su token
      await _authService.logginUser(authenticate);


      
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);


    } else {
      if(photo != null)
      {
        await _cloudService.deleteImage(value["public_id"]);
      }
      _showAlert(context);
    }

    //Navigator.of(context).pushNamed('/home');
  }

  List<Step> getSteps() => [
        Step(
          isActive: _currentStep >= 0,
          title: const Text('Cuenta'),
          content: _makeBackground(context),
        ),
        Step(
          isActive: _currentStep >= 1,
          title: const Text('Informacion adicional'),
          content: _makeBackground(context),
        )
      ];

  void getUniversities() async {
    var univResponse = await _instituteService.getAllInstitutes();
    setState(() {
      _universities = (univResponse['institutes'] as List)
          .map((item) => Institute.fromJson(item)).toList();

      _valueUniversity = _universities.first;
    });

    getCareers(_valueUniversity.id);
  }

  void getCareers(int id) async {
    var careerResponse = await _careerService.getCareersByInstituteId(id);
    setState(() {
      if (careerResponse['ok']) {
        _careers = (careerResponse['careers'] as List)
            .map((item) => Career.fromJson(item)).toList();

        _valueCareer = _careers.first;
      } else {
        _careers = [
          Career(id: 0, name: "")
        ];
        _valueCareer = _careers.first;
      }
    });

    _isLoadingValues = false;
  }

  void _selectImage() async {
    var photoTemp = await _imagePicker.pickImage(
        source: ImageSource.gallery
    );

    if(photoTemp != null) {
      setState(() {
        photo = File(photoTemp.path);
      });

    }

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
