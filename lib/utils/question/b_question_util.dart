import 'dart:convert';

import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class BQuestionUtil{
  static final BQuestionUtil _bQuestionUtil=BQuestionUtil();
  static BQuestionUtil get instance=>_bQuestionUtil;


  final List<QuestionBean> _allQuizList=[];
  
  initQuiz(){
    _allQuizList.addAll(_initList(mathStrBase64));
    _allQuizList.addAll(_initList(historyStrBase64));
    _allQuizList.addAll(_initList(natureStrBase64));
    _allQuizList.addAll(_initList(scienceStrBase64));
    _allQuizList.addAll(_initList(animalStrBase64));
    _allQuizList.addAll(_initList(dailyLifeStrBase64));
  }

  QuestionBean getCurrentQuiz(){
    var answerIndex = BSql.instance.bUserInfo?.answerIndex??0;
    if(answerIndex>=_allQuizList.length){
      BSql.instance.bUserInfo?.answerIndex=0;
      BSql.instance.updateUserInfo();
      return _allQuizList.first;
    }
    return _allQuizList[answerIndex];
  }

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