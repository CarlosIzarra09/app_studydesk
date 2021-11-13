import 'package:app_studydesk/src/pages/add_detail_session_page.dart';
import 'package:app_studydesk/src/pages/add_session_page.dart';
import 'package:app_studydesk/src/pages/book_session_page.dart';
import 'package:app_studydesk/src/pages/download_doc_page.dart';
import 'package:app_studydesk/src/pages/home_page.dart';
import 'package:app_studydesk/src/pages/login_page.dart';
import 'package:app_studydesk/src/pages/register_page.dart';
import 'package:app_studydesk/src/pages/sessions_page.dart';
import 'package:app_studydesk/src/pages/upload_doc_page.dart';
import 'package:flutter/material.dart';

import 'models/user_tutor.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case '/login':return MaterialPageRoute(builder: (context)=> const LoginPage() ) ;
      case '/register':return MaterialPageRoute(builder: (context)=> const RegisterPage() );
      case '/home':return MaterialPageRoute(builder: (context)=> const HomePage() );
      case '/upload': return MaterialPageRoute(builder: (context)=> const UploadDocumentsPage() );
      case '/download': return MaterialPageRoute(builder: (context)=> const DownloadPage() );
      case '/add-session':
        final Map parameters = (settings.arguments as Map);
        return MaterialPageRoute(builder: (context)=> AddSessionPage(parametersSession: parameters,) );
      case '/detail-session':
        final UserTutor tutor = (settings.arguments as UserTutor);
        return MaterialPageRoute(builder: (context)=> AddDetailSessionPage(userTutor: tutor,) );
      case '/sessions':return MaterialPageRoute(builder: (context)=> const SessionsPage() );
      case '/book-session':
        final int tutorId = (settings.arguments as int);
        return MaterialPageRoute(builder: (context)=> BookSessionPage(tutorId: tutorId,) );
      default: return _errorRoute();

    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context){
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}