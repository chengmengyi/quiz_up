import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/sql/base_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class UserInfoKey{
  static const String coin="coin";
  static const String heart="heart";
  static const String answerNum="answerNum";
}

class ASql extends BaseSql{
  static final ASql _sql=ASql();
  static ASql get instance  => _sql;

  initQuestionAndUserInfoData()async{
    var db = await initDB();
    if((await db.query(TableName.questionInfoA)).isEmpty){
      db.insert(TableName.questionInfoA, {"mathIndex":0,"historyIndex":0,"natureIndex":0,"scienceIndex":0,"animalIndex":0,"dailyIndex":0});
    }
    var infoList = await db.query(TableName.userInfoA);
    if(infoList.isEmpty){
      db.insert(TableName.userInfoA, {"coin":0,"heart":10,"answerNum":0,"lastHeartTimer": getTodayTime()});
    }else{
      var map = infoList.first;
      if(map["lastHeartTimer"]!=getTodayTime()){
        var newMap = Map<String, Object?>.from(map);
        newMap["lastHeartTimer"]=getTodayTime();
        newMap["heart"]=10;
        db.update(TableName.userInfoA, newMap ,where: '"id" = ?', whereArgs: [map["id"]]);
      }
    }
  }

  Future<int> queryQuestionIndex(String questionType)async{
    var db = await initDB();
    var list = await db.query(TableName.questionInfoA);
    if(list.isEmpty){
      return 0;
    }
    return list.first[_getQuestionInfoKeyByType(questionType)] as int;
  }

  Future<void> updateQuestionIndex(String questionType)async{
    var db = await initDB();
    var list = await db.query(TableName.questionInfoA);
    if(list.isEmpty){
      return;
    }
    var map = list.first;
    var newMap = Map<String, Object?>.from(map);
    var key = _getQuestionInfoKeyByType(questionType);
    var currentIndex = map[key] as int;
    if(currentIndex>=AQuestionUtils.instance.getQuestionMax(questionType)-1){
      currentIndex=-1;
    }
    newMap[key]=currentIndex+1;
    await db.update(TableName.questionInfoA, newMap ,where: '"id" = ?', whereArgs: [map["id"]]);
  }

  Future<int> getUserInfo(String key)async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoA);
    print(list);
    if(list.isEmpty){
      return 0;
    }
    return list.first[key] as int;
  }

  updateUserInfo(String key,int addNum)async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoA);
    if(list.isEmpty){
      return;
    }
    var map = list.first;
    var newMap = Map<String, Object?>.from(map);
    newMap[key]=(map[key] as int ) + addNum;
    await db.update(TableName.userInfoA, newMap ,where: '"id" = ?', whereArgs: [map["id"]]);
    switch(key){
      case UserInfoKey.coin:
        SendEvent(code: EventCode.updateCoins).send();
        break;
      case UserInfoKey.heart:
        SendEvent(code: EventCode.updateHeart).send();
        break;
      case UserInfoKey.answerNum:
        SendEvent(code: EventCode.updateAnswerNum).send();
        break;
    }
  }

  String _getQuestionInfoKeyByType(String questionType){
    switch(questionType){
      case QuestionType.math: return "mathIndex";
      case QuestionType.history: return "historyIndex";
      case QuestionType.nature: return "natureIndex";
      case QuestionType.science: return "scienceIndex";
      case QuestionType.animal: return "animalIndex";
      case QuestionType.dailyLife: return "dailyIndex";
      default: return "mathIndex";
    }
  }
}