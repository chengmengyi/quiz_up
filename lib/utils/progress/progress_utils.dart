import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/bean/progress_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/box/box_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/wheel/wheel_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class ProgressUtils{
  static final ProgressUtils _utils=ProgressUtils();
  static ProgressUtils get instance=>_utils;
  final List<int> _receivedIndexList=[];
  final List<ProgressBean> progressList=[];

  getProgressList()async{
    var list = await BSql.instance.queryReceivedIndexList();
    _receivedIndexList.addAll(list);
    var quizNum = BQuestionUtil.instance.getAllQuizNum();
    progressList.clear();
    for(int index=0;index<quizNum;index++){
      if(index==0){
        progressList.add(ProgressBean(progressType: ProgressType.empty, received: false));
      }else{
        var box=index==1||index==5||(index-1)%4==0;
        var wheel=index==9||(index-9)%12==0;
        progressList.add(ProgressBean(progressType: wheel?ProgressType.wheel:box?ProgressType.box:ProgressType.empty, received: _receivedIndexList.contains(index)));
      }
    }
  }

  receiveBoxOrWheel(index)async{
    _receivedIndexList.add(index);
    await BSql.instance.updateReceivedIndex(index);
    progressList[index].received=true;
    SendEvent(code: EventCode.updateBoxOrWheelPro).send();
  }

  bool emptyProHasValue(index){
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    return answerNum-1>=index;
  }

  bool showLeftPro(index){
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    return answerNum>=index;
  }

  bool showRightPro(index){
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    return answerNum>index;
  }

  bool showFinger(int index){
    var indexWhere = progressList.indexWhere((value)=>value.progressType!=ProgressType.empty&&!value.received&&(BSql.instance.bUserInfo?.answerNum??0)-1>=index);
    if(indexWhere>=0){
      return indexWhere==index;
    }
    return false;
  }

  clickBoxOrWheel(index,canReceive){
    var bean = progressList[index];
    if(!canReceive){
      if(bean.received){
        if(bean.progressType==ProgressType.box){
          showToast("Today’s treasure chest reward has been collected");
        }
        if(bean.progressType==ProgressType.wheel){
          showToast("The wheel reward has been received");
        }
      }
      return;
    }
    if(bean.progressType==ProgressType.box){
      showDialog(
          widget: BoxDialog(index: index,)
      );
    }
    if(bean.progressType==ProgressType.wheel){
      showDialog(
          useSafeArea: false,
          widget: WheelDialog(autoWheel: false,receivedIndex: index,)
      );
    }
  }
}