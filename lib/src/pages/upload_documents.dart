import 'dart:convert';
import 'dart:ui';

import 'package:app_studydesk/src/models/Document.dart';
import 'package:app_studydesk/src/models/career.dart';
import 'package:app_studydesk/src/models/course.dart';
import 'package:app_studydesk/src/models/institute.dart';
import 'package:app_studydesk/src/models/student_material.dart';
import 'package:app_studydesk/src/models/study_material.dart';
import 'package:app_studydesk/src/models/topic.dart';
import 'package:app_studydesk/src/services/career_service.dart';
import 'package:app_studydesk/src/services/course_service.dart';
import 'package:app_studydesk/src/services/institute_service.dart';
import 'package:app_studydesk/src/services/student_material_service.dart';
import 'package:app_studydesk/src/services/topic_material_service.dart';
import 'package:app_studydesk/src/services/topic_service.dart';
import 'package:app_studydesk/src/share_preferences/user_preferences.dart';
import 'package:app_studydesk/src/util/double_round.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadDocumentsPage extends StatefulWidget {
  const UploadDocumentsPage({Key? key}) : super(key: key);

  @override
  _UploadDocumentsPageState createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Bienvenido Rodrigo"),
      ),
      body: SingleChildScrollView(
        child:  Container(
        child: Column(
          children: <Widget> [
            InputWidget(),
          ]
        ),

        margin: EdgeInsets.all(20.0),
        width: 500,
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}


class InputWidget extends StatefulWidget {
  const InputWidget({Key? key}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidget();
}

/// This is the private State class that goes with MyStatefulWidget.
class _InputWidget extends State<InputWidget> {

  Institute _valueUniversity = Institute(id: 0, name: "Universidad");
  Career _valueCareer = Career(id: 0, name: "Carrera");
  Course _valueCourse = Course(id: 0, name: "Course");
  Topic _valueTopic = Topic(id: 0, name: "Topico");

  int topicId = 1;

  List<Institute> _universities = [];
  List<Career> _careers = [];
  List<Course> _courses = [];
  List<Topic> _topics = [];
  List<StudyMaterial> _listDocuments = [];

  bool _isLoadingValues = true;
  bool _isLoadingCareersValues = false;
  bool _isLoadingCoursesValues = false;
  bool _isLoadingTopicsValues = false;

  final InstituteService _instituteService = InstituteService();
  final _careerService = CareerService();
  final _courseService = CourseService();
  final _topicService = TopicService();
  final TopicMaterialService _topicMaterialService = TopicMaterialService();
  final StudentMaterialService _studentMaterialService = StudentMaterialService();

  bool permissionGranted = false;
  bool showCharging = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final fileController = TextEditingController();

  //late SharedPreferences _prefs;
  late UserPreferences _userPrefs = UserPreferences();
  String _fileName = "no hay archivo seleccionado";
  late String? _filePath;
  double _sizeFile = 0.0;

  final String _dropboxClientId = 'app_studydesk';
  final String _dropboxKey = 'qti8nv7gtv9pzt6';
  final String _dropboxSecret = 'h69j30akedi52id';
  final String _accessToken =
      "gJIqPRL6Dl0AAAAAAAAAAURMZkmntGOdGCy2UUZPfsmJW6OeMe9GDQ3SoZ1Njyic";


  //String _ProgressCount = "0.0/0.0";
  double _percentage = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDropbox();
    getUniversities();
  }

  Future initDropbox() async {
    await Dropbox.init(_dropboxClientId, _dropboxKey, _dropboxSecret);
    //_prefs = await SharedPreferences.getInstance();
    //_prefs.setString('dropboxAccessToken', _accessToken);
    //_userPrefs.Token = _accessToken;
    await _authorizeWithAccessToken();

    setState(() {});
  }

  Future _authorizeWithAccessToken() async {
    await Dropbox.authorizeWithAccessToken(_accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image(image: AssetImage("assets/texts/studydesk_title_logo.png")),
              margin: EdgeInsets.only(top: 10),
            ),
            Container(
              child: const Text(
                "Universidades",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
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
                    _isLoadingCareersValues = true;
                    getCareers(value.id);
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ),
              margin: EdgeInsets.only(top: 5),
            ),
            Container(
              child: const Text(
                "Carreras",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
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
                onChanged: (_isLoadingCareersValues || _valueCareer.name=="")? null :(value) {
                  setState(() {
                    _valueCareer = value!;
                    _isLoadingCoursesValues = true;
                    getCourses(_valueCareer.id);
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ),

            ),
            Container(
              child: const Text(
                "Cursos",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              child: DropdownButton<Course>(
                menuMaxHeight: 600,
                disabledHint: Text(_valueCourse.name),
                borderRadius: BorderRadius.circular(5),
                underline: const SizedBox(),
                value: _valueCourse,
                isExpanded: true,
                items: _courses
                    .map<DropdownMenuItem<Course>>((item) {
                  return DropdownMenuItem<Course>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
                onChanged: (_isLoadingCoursesValues || _valueCourse.name=="")? null :(value) {
                  setState(() {
                    _valueCourse = value!;
                    _isLoadingTopicsValues = true;
                    getTopics(_valueCourse.id);
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ),
            ),
            Container(
              child: const Text(
                "Topicos",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              child: DropdownButton<Topic>(
                menuMaxHeight: 600,
                disabledHint: Text(_valueTopic.name),
                borderRadius: BorderRadius.circular(5),
                underline: const SizedBox(),
                value: _valueTopic,
                isExpanded: true,
                items: _topics
                    .map<DropdownMenuItem<Topic>>((item) {
                  return DropdownMenuItem<Topic>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
                onChanged: (_isLoadingCoursesValues || _valueTopic.name=="")? null :(value) {
                  setState(() {
                    _valueTopic = value!;
                    topicId = value.id;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: titleController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter your title',
                  labelText: "Title",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              child: TextFormField(
                controller: descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter your description',
                  labelText: "Description",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              child: Text(_fileName, textAlign: TextAlign.center),
              margin: EdgeInsets.only(top: 50),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child:ElevatedButton(
                  onPressed: _selectFile,
                  child: const Text('Seleccionar'),

                ),
              ),
              width: 500,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _uploadFile,
                  child: const Text('Subir Documento'),
                  
                ),
              ),
              width: 500,
            )

          ],
        ),
      ),
      width: 300,
    );


  }
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
    getCourses(_valueCareer.id);
    _isLoadingCareersValues = false;
  }

  void getCourses(int careerid) async {
    var courseResponse = await _courseService.getCoursesByCareerId(careerid);
    setState(() {
      if (courseResponse['ok']) {
        _courses = (courseResponse['courses'] as List)
            .map((item) => Course.fromJson(item)).toList();

        _valueCourse = _courses.first;
      } else {
        _courses = [
          Course(id: 0, name: "")
        ];
        _valueCourse = _courses.first;
      }
    });
    getTopics(_valueCourse.id);
    _isLoadingCoursesValues = false;
  }

  void getTopics(int courseId) async {
    var topicResponse = await _topicService.getTopicByCourseId(courseId);
    setState(() {
      if (topicResponse['ok']) {
        _topics = (topicResponse['topics'] as List)
            .map((item) => Topic.fromJson(item)).toList();

        _valueTopic = _topics.first;
      } else {
        _topics = [
          Topic(id: 0, name: "")
        ];
        _valueTopic = _topics.first;
      }
    });

    _isLoadingTopicsValues = false;
  }

  void _getDocuments() async {
    //Este es el topicId que seleccioné de un dropdown button
    setState(() {
      showCharging = true;
    });
    Map<String,dynamic> response = await _topicMaterialService.getAllStudyMaterialsByTopicId(topicId);
    setState(() {
      showCharging = false;
      _listDocuments = (response['studyMaterials'] as List).map((i) => StudyMaterial.fromJson(i)).toList();
    });

    //print(response);
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      //File file = File(result.files.single.path!);
      PlatformFile file = result.files.first;
      //print("Url de la imagen");
      //print(file.path);

      setState(() {
        _percentage = 0.0;
        _fileName = file.name;
        _filePath = file.path!;
        _sizeFile = roundDouble(file.size*0.000001, 2);
      });
    } else {


      setState(() {
        _filePath = null;
        _percentage = 0.0;
        _fileName = "no hay archivo seleccionado";
      });

      print('No seleccionó un archivo');
      // User canceled the picker
    }
  }

  Future _uploadFileDropbox(String filepath) async {

    //Esta ruta la sacamos de Institute / Career / Course / Topic

    final result = await Dropbox.upload(filepath,
        '/${_valueUniversity.name}/${_valueCareer.name}/${_valueCourse.name}/${_valueTopic.name}/$_fileName',
            (uploaded, total) {
          setState(() {
            //_ProgressCount = '$uploaded / $total';
            _percentage = uploaded/total;
          });
          //print('progress $uploaded / $total');
        });
    //print(result);
  }

  void _uploadFile() async {
    if(_filePath != null) {
      //sacarlo de un dropdown de maps
      int topicId = _valueTopic.id;
      int studentId = _userPrefs.id;
      await _uploadFileDropbox(_filePath!);

      //registramos en db el archivo
      var respStudyMat = await _topicMaterialService.postStudyMaterialByTopicId(topicId,
          StudyMaterial(
              title: titleController.text,
              description: descriptionController.text,
              fileName: _fileName,
              filePath: '/${_valueUniversity.name}/${_valueCareer.name}/${_valueCourse.name}/${_valueTopic.name}/$_fileName',
              size: _sizeFile)
      );

      print(respStudyMat);

      if(respStudyMat['ok']) {
        //registramos en db que pertenece a un usuario
        var respStudentMat = await _studentMaterialService.postStudentMaterialByStudentId(studentId,
            StudentMaterial(studyMaterialId: respStudyMat['id'])
        );

        print(respStudentMat);
      }


    }
  }

}



Future<Document> postDocument(title, description, file) async {
  var bodys = {
    "title": title,
    "description": description,
    "fileUrl": file,
    "topicId": 2
  };
  final res = await http.post(Uri.parse("https://studydeskapi.azurewebsites.net/api/studymaterials"), headers: {
    "content-type": "application/json"
  }, body: jsonEncode(bodys));

  return documentsFromJson(res.body);
}

