import 'dart:convert';

import 'package:app_studydesk/src/models/Document.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      body: Container(
        child: Column(
          children: <Widget> [
            InputWidget(),
          ]
        ),

        margin: EdgeInsets.all(20.0),
        width: 500,
      ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final fileController = TextEditingController();

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
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              child: TextFormField(
                controller: titleController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter your description',
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
              child: TextFormField(
                controller: fileController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter your URL File',
                  labelText: "File",
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      print(titleController.text);
                      print(descriptionController.text);
                      print(fileController.text);

                      postDocument(titleController.text, descriptionController.text, fileController.text);
                      showDialog<String>(context: context, builder: (BuildContext context) => AlertDialog(
                          title: Text("Documento subido con éxito!"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pushNamed("/home"),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushNamed("/home"),
                            child: const Text('OK'),
                          ),
                        ],
                      ));
                    }
                  },
                  child: const Text('Subir Documento'),
                  
                ),
              ),
              width: 500,
              margin: EdgeInsets.only(top: 30),
            )

          ],
        ),
      ),
      width: 300,
    );

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

  return documentFromJson(res.body);
}