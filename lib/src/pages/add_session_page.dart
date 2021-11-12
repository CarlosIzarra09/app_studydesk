import 'package:app_studydesk/src/models/platform_session.dart';
import 'package:app_studydesk/src/models/session.dart';
import 'package:app_studydesk/src/models/zoom_meeting.dart';
import 'package:app_studydesk/src/services/platform_service.dart';
import 'package:app_studydesk/src/services/session_service.dart';
import 'package:app_studydesk/src/services/zoom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSessionPage extends StatefulWidget {
  const AddSessionPage({Key? key, required this.parametersSession})
      : super(key: key);
  final Map parametersSession;

  @override
  _AddSessionPageState createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _textDateController = TextEditingController();
  String _titleSession = "";
  String _descriptionSession = "";
  DateTime? _startDate;
  DateTime? _endDate;

  int _valueQuantity = 1;
  int _valueHours = 1;
  double _valuePrice = 0.0;
  final SessionService _sessionService = SessionService();
  final PlatformService _platformService = PlatformService();
  final ZoomService _zoomService = ZoomService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendar una sesion"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40,),
            const Text(
              "Nueva sesión de tutoría",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Doris-P", fontSize: 40),
            ),
            _formSession(),
          ],
        ),
      ),
    );
  }

  Widget _formSession() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          _titleFormField(),
          const SizedBox(
            height: 20,
          ),
          _descriptionFormField(),
          const SizedBox(
            height: 20,
          ),
          _rowPriceAndMembers(),
          const SizedBox(
            height: 20,
          ),
          _startDateDatePicker(),
          const SizedBox(
            height: 20,
          ),
          _durationDropDown(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: _registerSession,
              child: const Text("Registrar sesión")),

          //_passwordFormField(),
        ],
      ),
    );
  }

  Widget _titleFormField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          maxLength: 40,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Teorema de pitágoras',
              labelText: 'Ingrese el titulo'
              //labelText: 'Ingresa el titulo',
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el titulo';
            }
            return null;
          },
          onChanged: (value) {
            _titleSession = value;
          },
        ));
  }

  Widget _descriptionFormField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        maxLength: 120,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Esta tutoria abarcará los temas de ......',
          labelText: 'Ingrese la descripción de su tutoria',
          alignLabelWithHint: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese la descripción de la tutoria';
          }
          return null;
        },
        onChanged: (value) {
          _descriptionSession = value;
        },
      ),
    );
  }

  Widget _rowPriceAndMembers() {
    return SizedBox(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            const Text("Precio"),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: "5.00",
                  isDense: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese precio';
                }
                return null;
              },
              onChanged: (value) {
                if(value != "") {
                  _valuePrice = double.parse(value.replaceAll(",", "."));
                }
              },
            )),
            /*const SizedBox(
              width: 80,
            ),*/
            const SizedBox(
              width: 10,
            ),
            const Text("Miembros"),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<int>(
                  underline: const SizedBox(),
                  value: _valueQuantity,
                  isExpanded: true,
                  items: <int>[1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valueQuantity = value!;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ));
  }

  Widget _startDateDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _textDateController,
        enableInteractiveSelection: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Fecha de inicio de la sesión',
            hintText: "20 de enero del 2021",
            icon: Icon(Icons.calendar_today)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione la fecha de su tutoria';
          }
          return null;
        },
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectDate();
        },
      ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      locale: const Locale('es', 'ES'),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
          context: context, initialTime: const TimeOfDay(hour: 12, minute: 00));
      if (pickedTime != null) {
        pickedDate = pickedDate
            .add(Duration(hours: pickedTime.hour, minutes: pickedTime.minute));
        setState(() {
          _startDate = pickedDate!;
          _textDateController.text =
              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"
              " a las ${pickedDate.hour}:${pickedDate.minute}";
        });
      }
    }
  }

  Widget _durationDropDown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          const Text("Seleccione la duración de su tutoria"),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<int>(
                underline: const SizedBox(),
                value: _valueHours,
                isExpanded: true,
                items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value horas"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valueHours = value!;
                  });
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerSession() async {
    if (_formKey.currentState!.validate()) {
      _endDate = _startDate!.add(Duration(hours: _valueHours));

      if (widget.parametersSession["Platform"] == "Zoom") {
        var responseZoom = await _createZoomRoom();
        if (responseZoom["ok"]) {
          var platformResp = await _platformService.postPlatformSession(
              PlatformSession(
                  name: "Zoom", platformUrl: responseZoom["urlMeet"]));
          if (platformResp["ok"]) {
            final session = Session(
                title: _titleSession,
                logo:widget.parametersSession["urlImage"],
                description: _descriptionSession,
                startDate: _startDate!,
                endDate: _endDate!,
                quantityMembers: _valueQuantity,
                price: _valuePrice,
                categoryId: widget.parametersSession["categoryId"],
                platformId: platformResp["id"],
                topicId: widget.parametersSession["topicId"]);

            var response = await _sessionService.postSessionByTutorId(session);
            if (response["ok"]) {
              print("posteado sesion");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              print(
                  "Error al intentar publicar la session ${response["message"]}");
            }
          } else {
            print(
                "Error al intentar publicar la platform ${platformResp["message"]}");
          }
        } else {
          print("No se pudo programar la sesion en zoom");
        }
      }
    }
  }

  Future<Map<String, dynamic>> _createZoomRoom() async {
    var zoomMeeting = ZoomMeeting(
      topic: _titleSession,
      type: "2",
      agenda: _descriptionSession,
      startTime: _startDate!.toIso8601String(),
      duration: _valueHours.toString(),
      timezone: "America/Lima",
    );
    var response = await _zoomService.requestRoom(zoomMeeting);
    return response;
  }
}
