import 'dart:convert';

import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class QuestionType{
  static const String math="Math";
  static const String history="History";
  static const String nature="Nature";
  static const String science="Science";
  static const String animal="Animal";
  static const String dailyLife="DailyLife";
}

class AQuestionUtils{
  static final AQuestionUtils _instance = AQuestionUtils();
  static AQuestionUtils get instance => _instance;

  final Map<String,List<QuestionBean>> _quesMap={};

  initQuestionList(){
    _quesMap[QuestionType.math]=_initList(mathStrBase64);
    _quesMap[QuestionType.history]=_initList(historyStrBase64);
    _quesMap[QuestionType.nature]=_initList(natureStrBase64);
    _quesMap[QuestionType.science]=_initList(scienceStrBase64);
    _quesMap[QuestionType.animal]=_initList(animalStrBase64);
    _quesMap[QuestionType.dailyLife]=_initList(dailyLifeStrBase64);
  }

  Future<List<QuestionBean>> getQuestionListByType(String type)async{
    var questionIndex = await ASql.instance.queryQuestionIndex(type);
    var list = _quesMap[type]??[];
    if(list.isEmpty){
      return [];
    }
    var start = questionIndex~/10*10;
    var end = questionIndex+10;
    if(end>list.length){
      end=list.length;
    }
    return list.sublist(start,end);
  }

  QuestionBean? getQuestionByIndex(String type,int index){
    try{
      var list = _quesMap[type];
      return list?[index];
    }catch(e){
      return null;
    }
  }

  int getQuestionMax(String type) => _quesMap[type]?.length??0;

  List<QuestionBean> _initList(String localStr){
    List<QuestionBean> list=[];
    try{
      var json = jsonDecode(localStr.base64());
      for(var value in json){
        list.add(QuestionBean.fromJson(value));
      }
      return list;
    }catch(e){
      return list;
    }
  }
}