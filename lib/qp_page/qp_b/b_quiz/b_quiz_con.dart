import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/progress_bean.dart';
import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_fail/a_answer_fail_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_right/a_answer_right_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_no_heart/a_no_heart_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/new_user/new_user_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BQuizCon extends GetxController implements EventListener{
  var chooseAnswerIndex=-1,level=0,timeInt=10,showBubble=false,_proMaxAnswerNum=0,_startProgressWidth=0.0;
  QuestionBean? currentQuestionBean;
  var questionType=QuestionType.animal;
  GlobalKey aGlobalKey=GlobalKey();
  GlobalKey bGlobalKey=GlobalKey();
  GlobalKey progressGlobalKey=GlobalKey();
  Offset? rightAnswerOffset;
  Timer? _timer;
  late ReceiveEvent receiveEvent;
  ScrollController scrollController=ScrollController();

  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _countProgressWidth();
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
      return;
    }
    var result = _checkResult();
    if(result){
      showDialog(
          widget: AnswerRightDialog(
            addNum: ValueUtils.instance.getQuizAddNum(),
            dismiss: (){
              _updateNextQuestion(true);
            },
          )
      );
    }else{
      _updateNextQuestion(false);
    }
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

  _updateNextQuestion(bool right)async{
    BSql.instance.updateUserAnswerNum(right);
    chooseAnswerIndex=-1;
    _getCurrentQuestion();
    update(["progress"]);
    jumpProgress();
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

  jumpProgress(){
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    if(_proMaxAnswerNum<=0||answerNum<_proMaxAnswerNum){
      return;
    }
    var startIndex=answerNum;
    for(int index=answerNum;index<ProgressUtils.instance.progressList.length;index++){
      var bean = ProgressUtils.instance.progressList[index];
      if(bean.progressType!=ProgressType.empty){
        startIndex=index;
        break;
      }
    }
    var pro = (startIndex/4).floor()*90.w+70.w-_startProgressWidth;
    scrollController.jumpTo(pro);
  }

  // double getProgress(double maxWidth){
  //   var answerNum = BSql.instance.bUserInfo?.answerNum??0;
  //   if()
  //   ProgressUtils.instance.getProgress(maxWidth);
  // }

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

  _countProgressWidth(){
    var renderBox = progressGlobalKey.currentContext!.findRenderObject() as RenderBox;
    var width=renderBox.size.width;
    if(width>0){
      var i = ((width-70.w)/90.w).floor();
      _proMaxAnswerNum=4*i+2;
      _startProgressWidth=70.w+i*90.w;
    }
  }

  @override
  void onClose() {
    _endTimer();
    receiveEvent.cancel();
    scrollController.dispose();
    super.onClose();
  }

  test(){
    if(!kDebugMode){
      return;
    }
    BSql.instance.updateUserMoney(1000);
    // BSql.instance.updateUserAnswerNum(true);
    // update(["progress"]);
    // jumpProgress();
  }
}