import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';

class OldUserCon extends GetxController{

  clickSpin(){
    back();
    GuideUtils.instance.updateOldUserStep(OldUserStep.showWheelDialog);
  }

  clickClose(){
    back();
  }
}