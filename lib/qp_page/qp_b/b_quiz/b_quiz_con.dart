import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_fail/a_answer_fail_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_right/a_answer_right_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_no_heart/a_no_heart_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/new_user/new_user_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class BQuizCon extends GetxController implements EventListener{
  var chooseAnswerIndex=-1,level=0,timeInt=10,showBubble=false;
  QuestionBean? currentQuestionBean;
  var questionType=QuestionType.animal;
  GlobalKey aGlobalKey=GlobalKey();
  GlobalKey bGlobalKey=GlobalKey();
  Offset? rightAnswerOffset;
  Timer? _timer;
  late ReceiveEvent receiveEvent;

  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _getCurrentQuestion();
    GuideUtils.instance.checkUserGuide();
  }

  clickResult(index)async{
    if(chooseAnswerIndex!=-1){
      return;
    }
    rightAnswerOffset=null;
    chooseAnswerIndex=index;
    update(["answer","finger"]);
    _endTimer();
    await Future.delayed(Duration(milliseconds: 800));
    if(GuideUtils.instance.isNewUserFirstStep()){
      GuideUtils.instance.updateNewUserStep(NewUserStep.showNewUserDialog);
    }
    // var result = _checkResult();
    // if(result){
    //   showDialog(
    //       widget: AAnswerRightDialog(
    //         dismiss: (){
    //           _updateNextQuestion();
    //         },
    //       )
    //   );
    // }else{
    //   showDialog(
    //       widget: AAnswerFailDialog(
    //         dismiss: (again){
    //           if(again){
    //             chooseAnswerIndex=-1;
    //             update(["question","answer"]);
    //           }else{
    //             _updateNextQuestion();
    //           }
    //         },
    //       )
    //   );
    // }
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
    level=(BSql.instance.bUserInfo?.answerNum??0)~/5;
    currentQuestionBean=BQuestionUtil.instance.getCurrentQuiz();
    update(["question","answer","level"]);
    _startTimer();
  }

  clickClose(){
    if(chooseAnswerIndex!=-1){
      return;
    }
    back();
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
  receivedEvent(SendEvent event) {
    switch(event.code){
      case EventCode.newUserStepOne:
        showRightAnswerFinger();
        break;
      case EventCode.newUserStepTwo:
        _endTimer();
        showDialog(
          widget: NewUserDialog(
            dismiss: (){
              GuideUtils.instance.updateNewUserStep(NewUserStep.toCashPage);
            },
          )
        );
        break;
      case EventCode.showBubble:
        showBubble=true;
        update(["bubble"]);
        break;
    }
  }

  @override
  void onClose() {
    _endTimer();
    receiveEvent.cancel();
    super.onClose();
  }

  test(){
    if(!kDebugMode){
      return;
    }
    GuideUtils.instance.checkUserGuide();
  }
}