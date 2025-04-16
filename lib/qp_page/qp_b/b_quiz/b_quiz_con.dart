import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as ma;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/progress_bean.dart';
import 'package:quiz_up/bean/question_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/box/box_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/new_user/new_user_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/open_notification/open_notification_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/wheel/wheel_dialog.dart';
import 'package:quiz_up/qp_dialog/loading_dialog.dart';
import 'package:quiz_up/qp_page/qp_b/test.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/firebase_utils.dart';
import 'package:quiz_up/utils/guide/box_guide_overlay.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/guide/wheel_guide_overlay.dart';
import 'package:quiz_up/utils/h5_utils.dart';
import 'package:quiz_up/utils/local_notifications/local_notifications_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BQuizCon extends GetxController with GetTickerProviderStateMixin implements EventListener{
  BuildContext? context;
  var chooseAnswerIndex=-1,level=0,timeInt=5,showBubble=false,_proMaxAnswerNum=0,_startProgressWidth=0.0,showMoneyLottie=false;
  QuestionBean? currentQuestionBean;
  var questionType=QuestionType.animal;
  GlobalKey aGlobalKey=GlobalKey();
  GlobalKey bGlobalKey=GlobalKey();
  GlobalKey progressGlobalKey=GlobalKey();
  GlobalKey box2GlobalKey=GlobalKey();
  GlobalKey wheel10GlobalKey=GlobalKey();
  Offset? rightAnswerOffset;
  Timer? _timer;
  late ReceiveEvent receiveEvent;
  ScrollController scrollController=ScrollController();
  late AnimationController moneyLottieController;


  var maxWidth=0.0,maxHeight=0.0,startRight=true,startDown=true,top=0.0,left=0.0;
  Timer? _bubbleTimer;
  double bubbleAddNum=ValueUtils.instance.getBubbleAddNum();

  @override
  void onInit() {
    super.onInit();
    _initMoneyLottieAnimator();
    PointUtils.instance.pointEvent(AppPointId.quiz_page);
    CheckUserUtils.instance.bQuizShow=true;
    receiveEvent=ReceiveEvent(eventListener: this);
    LocalNotificationsUtils.instance.setLocalNotifications();
    H5Utils.instance.pageB1();
    H5Utils.instance.pageB2();
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
    if(null!=rightAnswerOffset){
      PointUtils.instance.pointEvent(AppPointId.quiz_guide_c,data: {"source_from":GuideUtils.instance.isNewUserFirstStep()?"new":"other"});
    }
    rightAnswerOffset=null;
    chooseAnswerIndex=index;
    update(["answer","finger"]);
    _endTimer();
    BQuestionUtil.instance.updateTodayAnswerQuizNum();
    CashTaskUtils.instance.updateCashTask(TaskType.quiz);
    await Future.delayed(Duration(milliseconds: 800));
    if(GuideUtils.instance.isNewUserFirstStep()){
      _updateNextQuestion(true);
      GuideUtils.instance.updateNewUserStep(NewUserStep.showNewUserDialog);
      return;
    }
    var result = _checkResult();
    PointUtils.instance.pointEvent(result?AppPointId.answer_true:AppPointId.answer_wrong);
    if(result){
      showDialog(
          widget: AnswerRightDialog(
            addNum: ValueUtils.instance.getQuizAddNum(),
            type: AnswerRightTyp.quiz,
            dismiss: (){
              _updateNextQuestion(true);
            },
          )
      );
    }else{
      _updateNextQuestion(false);
    }
  }

  _updateNextQuestion(bool right)async{
    BSql.instance.updateUserAnswerNum(right);
    chooseAnswerIndex=-1;
    _getCurrentQuestion();
    update(["progress"]);
    jumpProgress();
    _checkShowBoxOverlay();
  }

  _checkShowBoxOverlay(){
    if(BSql.instance.bUserInfo?.answerNum==2&&null!=context){
      PointUtils.instance.pointEvent(AppPointId.box_guide);
      var renderBox = box2GlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      GuideUtils.instance.showGuideOver(
        context: context!,
        widget: BoxGuideOverlay(
          offset: offset,
          dismiss: (){
            PointUtils.instance.pointEvent(AppPointId.box_guide_c);
            showDialog(
              widget: BoxDialog(index: 1),
            );
          },
        ),
      );
    }

    if(BSql.instance.bUserInfo?.answerNum==10&&null!=context){
      PointUtils.instance.pointEvent(AppPointId.wheel_guide);
      var renderBox = wheel10GlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      GuideUtils.instance.showGuideOver(
        context: context!,
        widget: WheelGuideOverlay(
          offset: offset,
          dismiss: (){
            PointUtils.instance.pointEvent(AppPointId.wheel_guide_c);
            showDialog(
              widget: WheelDialog(wheelFrom: WheelFrom.guide,autoWheel: false,receivedIndex: 9,),
            );
          },
        ),
      );
    }
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
    timeInt=5;
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
        _initBubbleTimer();
        break;
      case EventCode.updateBoxOrWheelPro:
        update(["progress"]);
        break;
      case EventCode.showMoneyLottie:
        showMoneyLottie=true;
        update(["money_lottie"]);
        moneyLottieController..reset()..forward();
        break;
      case EventCode.newUserGuideToCashPage:
        toNamed(
            routersName: QpRouName.bCash,
            arguments: {"fromNewUser":true},
            backCall: (result){
              GuideUtils.instance.updateNewUserStep(NewUserStep.newUserGuideCompleted);
              _startTimer();
            }
        );
        break;
      case EventCode.updateUserMoney:
        bubbleAddNum=ValueUtils.instance.getBubbleAddNum();
        update(["earn","bubble"]);
        break;
    }
  }


  _initBubbleTimer(){
    if(context==null){
      return;
    }
    var size = MediaQuery.of(context!).size;
    maxWidth=size.width-74.w;
    maxHeight=size.height-74.w;
    _bubbleTimer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(startRight){
        left++;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left>=maxWidth){
          startRight=false;
        }
      }else{
        left--;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left<=0){
          startRight=true;
        }
      }
      update(["bubble"]);
    });
  }


  clickBubble(){
    PointUtils.instance.pointEvent(AppPointId.float_c);
    CashTaskUtils.instance.updateCashTask(TaskType.pop);
    if(firstClickBubble.get()){
      firstClickBubble.save(false);
      _clickBubbleResult();
      return;
    }
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adPointId: AdPointId.kwrap_bubble_rv,
        closeAd: (){
          _clickBubbleResult();
        },
        failAd: (){
          _clickBubbleResult();
        }
    );
  }

  _clickBubbleResult()async{
    showBubble=false;
    update(["bubble"]);
    BSql.instance.updateUserMoney(bubbleAddNum);
    await Future.delayed(Duration(seconds: FirebaseUtils.instance.float_dis));
    showBubble=true;
    update(["bubble"]);
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

  _initMoneyLottieAnimator(){
    moneyLottieController=AnimationController(vsync: this,duration: const Duration(milliseconds: 600))..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        showMoneyLottie=false;
        update(["money_lottie"]);
        SendEvent(code: EventCode.updateUserMoney).send();
      }
    });
  }

  bool showAnswerMoneyIcon(int index){
    if(null==rightAnswerOffset||null==currentQuestionBean){
      return false;
    }
    if(index==0){
      return currentQuestionBean?.qpResult=="qp_first";
    }
    return currentQuestionBean?.qpResult=="qp_second";
  }

  @override
  void onClose() {
    _endTimer();
    receiveEvent.cancel();
    scrollController.dispose();
    super.onClose();
    CheckUserUtils.instance.bQuizShow=false;
  }

  test(){
    if(!kDebugMode){
      return;
    }
    // BSql.instance.updateUserMoney(799);
    // CashTaskUtils.instance.updateCashTask(TaskType.spin);
    // LocalNotificationsUtils.instance.setLocalNotifications();

    // BSql.instance.updateNewCashQuizOrTask(TaskType.quiz);

    Navigator.push(context!, ma.MaterialPageRoute(builder: (_)=>Test()));
  }
}