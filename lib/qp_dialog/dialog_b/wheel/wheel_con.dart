import 'dart:async';

import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class WheelCon extends GetxController{
  var autoWheel=false,currentWheelAngle=0.0,fromOldUser=false;
  Timer? _wheelTimer;
  
  @override
  void onReady() {
    super.onReady();
    if(autoWheel){
      startWheel(-1);
    }
  }
  
  startWheel(receivedIndex){
    if(null!=_wheelTimer){
      return;
    }
    var wheelAddNum = ValueUtils.instance.getWheelAddNum();
    var angel = _getAngleByMoney(wheelAddNum);
    var totalAngel=1080+angel;
    currentWheelAngle=0;
    update(["wheel"]);
    _wheelTimer=Timer.periodic(const Duration(milliseconds: 1), (t){
      currentWheelAngle++;
      update(["wheel"]);
      if(currentWheelAngle>=totalAngel){
        _stop(wheelAddNum,receivedIndex);
      }
    });
  }

  _stop(int wheelAddNum,receivedIndex)async{
    _wheelTimer?.cancel();
    await Future.delayed(Duration(milliseconds: 800));
    _wheelTimer=null;
    AdUtils.instance.showAd(
      adType: AdType.interstitial,
      adPointId: fromOldUser?AdPointId.kwrap_olduser_wheelspin_int:AdPointId.kwrap_wheelspin_int,
      closeAd: (){
        _watchAdFinish(wheelAddNum, receivedIndex);
      },
      failAd: (){
        _watchAdFinish(wheelAddNum, receivedIndex);
      }
    );
  }

  _watchAdFinish(int wheelAddNum,receivedIndex){
    back();
    BSql.instance.updateUserMoney(wheelAddNum.toDouble());
    if(fromOldUser){
      GuideUtils.instance.updateOldUserStep(OldUserStep.showDoubleDialog,wheelAddNum: wheelAddNum);
    }else{
      showDialog(
          widget: AnswerRightDialog(
            addNum: wheelAddNum.toDouble(),
            type: AnswerRightTyp.wheel,
            dismiss: (){
              CashTaskUtils.instance.updateCashTask(TaskType.spin);
              ProgressUtils.instance.receiveBoxOrWheel(receivedIndex);
            },
          )
      );
    }
  }
  
  _getAngleByMoney(int money){
    switch(money){
      case 5: return 0;
      case 10: return -300;
      case 20: return -240;
      case 50: return -180;
      case 80: return -120;
      default: return 0;
    }
  }

  clickClose(){
    if(null==_wheelTimer){
      back();
    }
  }
}