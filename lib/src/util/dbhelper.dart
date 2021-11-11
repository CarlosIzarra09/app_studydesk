import 'package:app_studydesk/src/models/user_student.dart';
import 'package:app_studydesk/src/models/user_tutor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final int _version = 1;
  static Database? _db;
  static final DbHelper myDatabase = DbHelper._();

  DbHelper._();

  Future<Database> get database async{
    if(_db != null) {
      return _db!;
    } else {
      _db = await openDb();
      return _db!;
    }
  }

  Future<Database> openDb() async{
    return await openDatabase(
          join(await getDatabasesPath(), 'studydesk.db'),
          version: _version,
          onCreate: (database,version){
            database.execute(''
                'CREATE TABLE Students(id INTEGER PRIMARY KEY, '
                'name TEXT, '
                'lastName TEXT,'
                'logo TEXT,'
                'email TEXT,'
                'isTutor INTEGER)');
            database.execute(''
                'CREATE TABLE Tutors(id INTEGER PRIMARY KEY, '
                'courseId INTEGER,'
                'name TEXT, '
                'lastName TEXT,'
                'email TEXT,'
                'logo TEXT,'
                'description TEXT,'
                'pricePerHour REAL)');
          },
          );
  }

  Future<int> insertStudent(UserStudent student) async{
    final db = await database;
    final res = await db.insert('Students',student.toDatabaseJson());

    //res es el ID del ultimo registro insertado
    //print(res);
    return res;
  }

  Future<int> insertTutor(UserTutor tutor) async{
    final db = await database;
    final res = await db.insert('Tutors',tutor.toDatabaseJson());

    //res es el ID del ultimo registro insertado
    return res;
  }

  Future<UserStudent?> getUserStudentByID(int id)async{
    final db = await database;
    final res = await db.query('Students',where:'id = ?',whereArgs: [id]);
    return res.isNotEmpty? UserStudent.fromDatabaseJson(res[0]):null;
  }

  Future<UserTutor?> getUserTutorByID(int id)async{
    final db = await database;
    final res = await db.query('Tutors',where:'id = ?',whereArgs: [id]);
    return res.isNotEmpty? UserTutor.fromDatabaseJson(res[0]):null;
  }

  Future<int> deleteAllStudents() async
  {
    final db = await database;
    final res = await db.delete('Students');
    return res;
  }

  Future<int> deleteAllTutors() async
  {
    final db = await database;
    final res = await db.delete('Tutors');
    return res;
  }


  /*Future testDB() async{
    db = await openDb();
    *//*await db!.execute('INSERT INTO lists VALUES(0,"DISCOS DUROS",1)');
   await db!.execute('INSERT INTO items VALUES(0,0,"SSD","5 unids","Marca Seagate")');*//*

    List list = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
  }*/




  /*Future<UserStudent> getLocalStudent() async{
    await initDB();
    var student = await db!.rawQuery('SELECT * FROM students');

  }*/





}