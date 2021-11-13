import 'package:app_studydesk/src/models/career.dart';
import 'package:app_studydesk/src/models/course.dart';
import 'package:app_studydesk/src/models/university.dart';
import 'package:app_studydesk/src/models/topic.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/services/career_service.dart';
import 'package:app_studydesk/src/services/user_tutor_service.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_studydesk/src/models/study_material.dart';
import 'package:app_studydesk/src/services/course_service.dart';
import 'package:app_studydesk/src/services/university_service.dart';
import 'package:app_studydesk/src/services/topic_material_service.dart';
import 'package:app_studydesk/src/services/topic_service.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  University _valueUniversity = University(id: 0, name: "none");
  Career _valueCareer = Career(id: 0, name: "none");
  Course _valueCourse = Course(id: 0, name: "none");
  Topic _valueTopic = Topic(id: 0, name: "none");

  int topicId = 1;

  int courseId = 1;

  final _universityService = UniversityService();
  final _careerService = CareerService();
  final _courseService = CourseService();
  final _topicService = TopicService();
  final _topicMaterialService = TopicMaterialService();
  final _tutorService = UserTutorService();

  List<University> _universities = [];
  List<Career> _careers = [];
  List<Course> _courses = [];
  List<Topic> _topics = [];
  List<StudyMaterial> _listDocuments = [];
  List<UserTutor> _listTutors = [];

  bool _isLoadingCareersValues = false;
  bool _isLoadingCoursesValues = false;
  bool  _isSearchTutors = false;




  final String _dropboxClientId = 'app_studydesk';
  final String _dropboxKey = 'qti8nv7gtv9pzt6';
  final String _dropboxSecret = 'h69j30akedi52id';
  final String _accessToken =
      "gJIqPRL6Dl0AAAAAAAAAAURMZkmntGOdGCy2UUZPfsmJW6OeMe9GDQ3SoZ1Njyic";

  bool permissionGranted = false;
  bool showCharging = false;



  Future initDropbox() async {
    await Dropbox.init(_dropboxClientId, _dropboxKey, _dropboxSecret);
    await _authorizeWithAccessToken();

    setState(() {});
  }

  Future _authorizeWithAccessToken() async {
    await Dropbox.authorizeWithAccessToken(_accessToken);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDropbox();
    getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Archivos'),
      ),
      //drawer:  DrawerWidget(),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Institutes -->>>>>>>>>>>>>>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Universidad',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<University>(
                    borderRadius: BorderRadius.circular(5),
                    menuMaxHeight: 550,
                    underline: const SizedBox(),
                    value: _valueUniversity,
                    isExpanded: true,
                    items: _universities
                        .map<DropdownMenuItem<University>>((item) {
                      return DropdownMenuItem<University>(
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

                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Carrera',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 30),
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Curso',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
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
                        _listTutors=[];
                        _valueCourse = value!;
                        courseId = value.id;
                        getTopics(_valueCourse.id);
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
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Tópico',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _getDocuments,
                child: const Text('Obtener documentos')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _getTutors,
                child: const Text('Obtener tutores')),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: (showCharging)? const Center(
                child: CircularProgressIndicator(strokeWidth: 6,),
              ) : (!_isSearchTutors) ? _listviewDocuments(context) : _listviewTutors(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _listviewDocuments(BuildContext context) {
    //return Container();
    //return FutureBuilder(builder: builder)
    return ListView.builder(
        itemCount:  _listDocuments.length,

        itemBuilder: (BuildContext context,int index){
          final StudyMaterial item = _listDocuments.elementAt(index);
          return CardDocument(
            item.fileName,
            item.size,
            item.filePath,
            item.title,
            item.description,
          );
          /*return ListTile(
            title: Text(_listDocuments.elementAt(index).fileName),
          );*/
        }
    );
  }

  Widget _listviewTutors(BuildContext context) {
    return ListView.builder(
      itemCount: _listTutors.length,

      itemBuilder: (BuildContext context, int index) {
        final UserTutor item = _listTutors.elementAt(index);
        return CardTutor(item.logo, item.name, item.description, item.id!);
      }
    );
  }

  void getUniversities() async {
    var univResponse = await _universityService.getAllUniversities();
    setState(() {
      _universities = (univResponse['universities'] as List)
          .map((item) => University.fromJson(item)).toList();

      _valueUniversity = _universities.first;
    });

    getCareers(_valueUniversity.id);
  }
  void getCareers(int id) async {
    var careerResponse = await _careerService.getCareersByUniversityId(id);
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

  }

  void _getDocuments() async {
    //Este es el topicId que seleccioné de un dropdown button
    setState(() {
      showCharging = true;
      _isSearchTutors = false;
    });
    Map<String,dynamic> response = await _topicMaterialService.getAllStudyMaterialsByTopicId(topicId);
    setState(() {
      showCharging = false;
      _listDocuments = (response['studyMaterials'] as List).map((i) => StudyMaterial.fromJson(i)).toList();
    });

    //print(response);
  }

  void _getTutors() async {
    setState(() {
      showCharging = true;
      _isSearchTutors = true;
    });

    Map<String,dynamic> response = await _tutorService.getAllTutorsByCourseId(courseId);
    setState(() {
      showCharging = false;
      _listTutors = (response['userTutors'] as List).map( (i) => UserTutor.fromJson(i)).toList();
    });
  }

  Widget CardDocument(String fileName,
      double size,
      String filePath,
      String title,
      String description) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.description,size: 80,),
                  ElevatedButton(onPressed: () => {
                    _downloadDocument(filePath,fileName)
                  },
                    child: Row(
                      children: const <Widget>[
                        Text('Descargar'),
                        SizedBox(width: 10,),
                        Icon(Icons.download)
                      ],
                    )
                  ),
                ],
              ),
              Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20,),
                    Text(title,
                      style: const TextStyle(
                          fontSize: 24,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 20,),
                    Text(description,textAlign: TextAlign.justify,maxLines: 2,overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 20,),
                    Text('Peso: $size mb'),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CardTutor(String logo, String name, String description, int tutorId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        margin: EdgeInsets.only(bottom: 20),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        logo,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                      Container(
                        width: 150,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              const SizedBox(height: 20,),
                              Text(name,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                              ),
                              const SizedBox(height: 20,),
                              Text(description, textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,)
                            ]
                        ),
                      ),
                    ],
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(onPressed: () => {

                      },
                        child: Row(
                          children: const <Widget>[
                            Text('Ver Datos'),
                            SizedBox(width: 10,),
                            Icon(Icons.data_usage),
                          ],

                        ),
                      ),
                      ElevatedButton(onPressed: () => {
                        Navigator.pushNamed(context, '/book-session', arguments: tutorId)
                      },
                        child: Row(
                          children: const <Widget>[
                            Text('Ver Sesiones'),
                            SizedBox(width: 10,),
                            Icon(Icons.tv)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),

            ],
          ),
        ),
      )

    );
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    }
  }

  void _downloadDocument(String filePath,String fileName) async {
    await _getStoragePermission();
    if(permissionGranted){


      await Dropbox.download(filePath, '/storage/emulated/0/Download/$fileName',
              (downloaded, total) {
            //print('progress $downloaded / $total');
            if(downloaded == total) {

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content:
              Row(
                  children: const <Widget>[
                    Icon(Icons.thumb_up,color: Colors.white,),
                    SizedBox(width: 20),
                    Text('Se completó la descarga!')
                  ]
              )
              ));
            }
          });
    }
  }
}
