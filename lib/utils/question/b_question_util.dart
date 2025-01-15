import 'dart:convert';

import 'package:in_app_review/in_app_review.dart';
import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/comment/comment/comment_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/comment/comment_success/comment_success_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
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

  int getAllQuizNum()=>_allQuizList.length;

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

  _showSystemDialog()async{
    var instance = InAppReview.instance;
    var ava = await instance.isAvailable();
    if(ava){
      instance.requestReview();
    }
  }

  updateTodayAnswerQuizNum(){
    var quizNum = getTodayNum(todayAnswerQuizNum.get())+1;
    todayAnswerQuizNum.save("${getTodayTime()}_$quizNum");
    if(!alreadyShowComment.get()&&(quizNum==3||quizNum==5)){
      showDialog(
          widget: CommentDialog(
            dismiss: (stars){
              alreadyShowComment.save(true);
              BSql.instance.updateUserMoney(5.0);
              if(stars<=2){
                showDialog(widget: CommentSuccessDialog());
              }else{
                _showSystemDialog();
              }
            },
          )
      );
    }
  }
}