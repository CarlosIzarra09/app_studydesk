import 'dart:io';

import 'package:app_studydesk/src/models/category.dart';
import 'package:app_studydesk/src/models/platform_session.dart';
import 'package:app_studydesk/src/models/topic.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:app_studydesk/src/services/category_service.dart';
import 'package:app_studydesk/src/services/cloudinary_service.dart';
import 'package:app_studydesk/src/services/topic_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDetailSessionPage extends StatefulWidget {
  const AddDetailSessionPage({Key? key, required this.userTutor})
      : super(key: key);
  final UserTutor userTutor;

  @override
  _AddDetailSessionPageState createState() => _AddDetailSessionPageState();
}

class _AddDetailSessionPageState extends State<AddDetailSessionPage> {
  File? photo;
  final _imagePicker = ImagePicker();
  Category _valueCategory = Category(id: 0, name: "");
  Topic _valueTopic = Topic(id: 0, name: "");
  PlatformSession _valuePlatform =
      PlatformSession(id: 0, name: "", platformUrl: "");

  List<Topic> _topics = [];
  List<Category> _categories = [];
  List<PlatformSession> _platforms = [];

  final _topicService = TopicService();
  final _categoryService = CategoryService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void initState() {
    super.initState();
    getTopics(widget.userTutor.courseId);
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles previos"),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          _addImageSession(),
          const SizedBox(
            height: 20,
          ),
          _dropDownButtonsSession(),
        ],
      ),
    );
  }

  Widget _addImageSession() {
    return Stack(
      children: <Widget>[
        Center(
          child: Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 5.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: (photo == null)
                ? const Image(
                    image: AssetImage("assets/images/placeholder_account.jpg"),
                    fit: BoxFit.cover,
                    height: 250,
                    width: 250,
                  )
                : Image.file(
                    photo!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200, left: 220),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
                primary: Colors.blue, // <-- Button color
                onPrimary: Colors.white, // <-- Splash color
              ),
              child: const Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: _selectImage,
            ),
          ),
        )
      ],
    );
  }

  void _selectImage() async {
    var photoTemp = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (photoTemp != null) {
      setState(() {
        photo = File(photoTemp.path);
      });
    }
  }

  void getTopics(int courseId) async {
    var topicResponse = await _topicService.getTopicByCourseId(courseId);
    setState(() {
      if (topicResponse['ok']) {
        _topics = (topicResponse['topics'] as List)
            .map((item) => Topic.fromJson(item))
            .toList();

        _valueTopic = _topics.first;
      } else {
        _topics = [Topic(id: 0, name: "")];
        _valueTopic = _topics.first;
      }
    });
  }

  void getCategories() async {
    _platforms = [
      PlatformSession(id: 1, name: "Zoom", platformUrl: ""),
      PlatformSession(id: 2, name: "Teams", platformUrl: ""),
    ];
    _valuePlatform = _platforms.first;
    var categoryResponse = await _categoryService.getAllCategories();
    setState(() {
      if (categoryResponse['ok']) {
        _categories = (categoryResponse['categories'] as List)
            .map((item) => Category.fromJson(item))
            .toList();

        _valueCategory = _categories.first;
      } else {
        _categories = [Category(id: 0, name: "")];
        _valueCategory = _categories.first;
      }
    });
  }

  Widget _dropDownButtonsSession() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Topico de la sesión"),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<Topic>(
                    menuMaxHeight: 600,
                    disabledHint: Text(_valueTopic.name),
                    borderRadius: BorderRadius.circular(5),
                    underline: const SizedBox(),
                    value: _valueTopic,
                    isExpanded: true,
                    items: _topics.map<DropdownMenuItem<Topic>>((item) {
                      return DropdownMenuItem<Topic>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valueTopic = value!;
                      });
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              const Text("Categoría de la sesión"),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<Category>(
                    menuMaxHeight: 600,
                    disabledHint: Text(_valueCategory.name),
                    borderRadius: BorderRadius.circular(5),
                    underline: const SizedBox(),
                    value: _valueCategory,
                    isExpanded: true,
                    items: _categories.map<DropdownMenuItem<Category>>((item) {
                      return DropdownMenuItem<Category>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valueCategory = value!;
                      });
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              const Text("Plataforma de la sesión"),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<PlatformSession>(
                    menuMaxHeight: 600,
                    disabledHint: Text(_valuePlatform.name),
                    borderRadius: BorderRadius.circular(5),
                    underline: const SizedBox(),
                    value: _valuePlatform,
                    isExpanded: true,
                    items: _platforms
                        .map<DropdownMenuItem<PlatformSession>>((item) {
                      return DropdownMenuItem<PlatformSession>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valuePlatform = value!;
                      });
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
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () {
                _passParametersToSessionPage();
              },
              child: const Text("Continuar registro"))
        ],
      ),
    );
  }

  void _passParametersToSessionPage() async {
    String urlImage =
        "https://res.cloudinary.com/dwhagi5eg/image/upload/v1636674995/gjipugw9leeg9tae72e4.png";
    if (photo != null) {
      var value = await _cloudinaryService.uploadImage(photo!);
      urlImage = value['secure_url'];
    }
    Navigator.of(context).pushNamed("/add-session", arguments: {
      "Platform": _valuePlatform.name,
      "categoryId": _valueCategory.id,
      "topicId": _valueTopic.id,
      "urlImage": urlImage
    });
  }
}
