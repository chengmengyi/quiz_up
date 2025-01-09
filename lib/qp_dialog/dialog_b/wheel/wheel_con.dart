import 'dart:async';

import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class WheelCon extends GetxController{
  var autoWheel=false,currentWheelAngle=0.0,fromOldUser=false;
  Timer? _wheelTimer;
  
  @override
  void onReady() {
    super.onReady();
    if(autoWheel){
      startWheel();
    }
  }
  
  startWheel(){
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
        _stop(wheelAddNum);
      }
    });
  }

  _stop(int wheelAddNum)async{
    _wheelTimer?.cancel();
    await Future.delayed(Duration(milliseconds: 800));
    _wheelTimer=null;
    AdUtils.instance.showAd(
      closeAd: (){
        back();
        BSql.instance.updateUserMoney(wheelAddNum.toDouble());
        if(fromOldUser){
          GuideUtils.instance.updateOldUserStep(OldUserStep.showDoubleDialog,wheelAddNum: wheelAddNum);
        }
      },
    );
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