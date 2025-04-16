import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_fail/a_answer_fail_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_right/a_answer_right_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_no_heart/a_no_heart_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class AQuestionCon extends GetxController{
  var chooseAnswerIndex=-1,questionIndex=0,questionLength=0,level=0,timeInt=10;
  QuestionBean? currentQuestionBean;
  var questionType=QuestionType.animal;
  GlobalKey aGlobalKey=GlobalKey();
  GlobalKey bGlobalKey=GlobalKey();
  Offset? rightAnswerOffset;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    questionType=QpRouters.getArguments()["type"];
  }

  @override
  void onReady() {
    super.onReady();
    _getCurrentQuestion();
  }

  clickResult(index)async{
    if(chooseAnswerIndex!=-1){
      return;
    }
    var heart = await ASql.instance.getUserInfo(UserInfoKey.heart);
    if(heart<=0){
      QpRouters.showDialog(
        widget: ANoHeartDialog()
      );
      return;
    }

    rightAnswerOffset=null;
    chooseAnswerIndex=index;
    update(["answer","finger"]);
    await Future.delayed(Duration(milliseconds: 800));
    var result = _checkResult();
    if(result){
      QpRouters.showDialog(
          widget: AAnswerRightDialog(
            dismiss: (){
              _updateNextQuestion();
            },
          )
      );
    }else{
      QpRouters.showDialog(
        widget: AAnswerFailDialog(
          dismiss: (again){
            if(again){
              chooseAnswerIndex=-1;
              update(["question","answer"]);
            }else{
              _updateNextQuestion();
            }
          },
        )
      );
    }
  }

  _updateNextQuestion()async{
    await ASql.instance.updateQuestionIndex(questionType);
    await ASql.instance.updateUserInfo(UserInfoKey.answerNum, 1);
    chooseAnswerIndex=-1;
    _getCurrentQuestion();
  }

  String getAnswerBg(index){
    if(chooseAnswerIndex==index&&!_checkResult()){
      return "q9";
    }
    return "q8";
  }

  String getResultIcon(index){
    if(chooseAnswerIndex!=index){
      return "";
    }
    return _checkResult()?"q10":"q11";
  }

  bool _checkResult(){
    if(chooseAnswerIndex==-1){
      return false;
    }
    if(chooseAnswerIndex==0){
      return currentQuestionBean?.qpResult=="qp_first";
    }
    return currentQuestionBean?.qpResult=="qp_second";
  }

  _getCurrentQuestion()async{
    if(questionLength==0){
      var list = await AQuestionUtils.instance.getQuestionListByType(questionType);
      questionLength=list.length;
    }
    if(questionIndex>=questionLength-1){
      QpRouters.back();
      return;
    }
    var index = await ASql.instance.queryQuestionIndex(questionType);
    var answerNum = await ASql.instance.getUserInfo(UserInfoKey.answerNum);
    level=answerNum~/5;
    questionIndex=index%10;
    currentQuestionBean=AQuestionUtils.instance.getQuestionByIndex(questionType, index);
    update(["question","answer","progress"]);
    _startTimer();
  }

  double getProgress(){
    if(questionLength==0){
      return 0;
    }
    var d = (questionIndex+1)/questionLength;
    if(d<=0){
      return 0;
    }else if(d>=1){
      return 1;
    }else{
      return d;
    }
  }

  clickClose(){
    if(chooseAnswerIndex!=-1){
      return;
    }
    QpRouters.back();
  }

  showRightAnswerFinger(){
    if(null==currentQuestionBean||null!=rightAnswerOffset){
      return;
    }
    var globalKey = currentQuestionBean?.qpResult=="qp_first"?aGlobalKey:bGlobalKey;
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    rightAnswerOffset = renderBox.localToGlobal(Offset.zero);
    update(["finger"]);
  }

  clickRightAnswerFinger(){
    if(null==currentQuestionBean){
      return;
    }
    clickResult(currentQuestionBean?.qpResult=="qp_first"?0:1);
  }

  _startTimer(){
    _endTimer();
    timeInt=10;
    update(["timer"]);
    _timer=Timer.periodic(Duration(milliseconds: 1000), (timer){
      timeInt--;
      update(["timer"]);
      if(timeInt<=0){
        _endTimer();
        showRightAnswerFinger();
      }
    });
  }

  _endTimer(){
    _timer?.cancel();
    _timer=null;
  }

  @override
  void onClose() {
    _endTimer();
    super.onClose();
  }
}