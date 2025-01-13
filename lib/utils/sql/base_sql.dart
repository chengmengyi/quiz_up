import 'package:sqflite/sqflite.dart';

class TableName{
  static const String questionInfoA="questionInfoA";
  static const String userInfoA="userInfoA";

  static const String userInfoB="userInfoB";
  static const String newUserGuideB="userGuideB";
  static const String oldUserGuideB="oldUserGuideB";
  static const String receivedIndexB="receivedIndexB";
  static const String cashTaskB="cashTaskB";
}

abstract class BaseSql{

  Future<Database> initDB()async{
    var db = await openDatabase(
        "qp.db",
        version: 2,
        onCreate: (db,version)async{
          db.execute('CREATE TABLE ${TableName.questionInfoA} (id INTEGER PRIMARY KEY AUTOINCREMENT, mathIndex INTEGER, historyIndex INTEGER, natureIndex INTEGER, scienceIndex INTEGER, animalIndex INTEGER, dailyIndex INTEGER)');
          db.execute('CREATE TABLE ${TableName.userInfoA} (id INTEGER PRIMARY KEY AUTOINCREMENT, coin INTEGER, heart INTEGER, answerNum INTEGER, lastHeartTimer TEXT)');

          _createVersion2DB(db);
        },
        onUpgrade: (db,oldVersion,newVersion){
          if(newVersion==2){
            _createVersion2DB(db);
          }
        }
    );
    return db;
  }

  _createVersion2DB(Database db) {
    db.execute('CREATE TABLE ${TableName.userInfoB} (id INTEGER PRIMARY KEY AUTOINCREMENT, money DOUBLE, answerRightNum INTEGER, answerNum INTEGER, answerIndex INTEGER)');
    db.execute('CREATE TABLE ${TableName.newUserGuideB} (id INTEGER PRIMARY KEY AUTOINCREMENT, newUserStep TEXT, completedTimer TEXT)');
    db.execute('CREATE TABLE ${TableName.oldUserGuideB} (id INTEGER PRIMARY KEY AUTOINCREMENT, oldUserStep TEXT, stepTimer TEXT)');
    db.execute('CREATE TABLE ${TableName.receivedIndexB} (id INTEGER PRIMARY KEY AUTOINCREMENT, receivedIndex INTEGER)');
    db.execute('CREATE TABLE ${TableName.cashTaskB} (id INTEGER PRIMARY KEY AUTOINCREMENT, cashType INTEGER, cashNum INTEGER, taskType TEXT, currentPro INTEGER, totalPro INTEGER, taskIndex INTEGER,account TEXT, taskStatus INTEGER)');
  }
}