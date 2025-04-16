import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';

class OldUserCon extends GetxController{
  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.old_user_pop);
  }

  clickSpin(){
    PointUtils.instance.pointEvent(AppPointId.old_user_pop_c);
    QpRouters.back();
    GuideUtils.instance.updateOldUserStep(OldUserStep.showWheelDialog);
  }

  clickClose(){
    QpRouters.back();
    GuideUtils.instance.updateOldUserStep(OldUserStep.showSignDialog);
  }
}