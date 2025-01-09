import 'package:get/get.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';

class BCashCon extends GetxController{
  @override
  void onInit() {
    super.onInit();
    _checkFromNewUser();
  }

  _checkFromNewUser(){
    var map = Get.arguments;
    if(map["fromNewUser"]==true){
      GuideUtils.instance.updateNewUserStep(NewUserStep.newUserGuideCompleted);
    }
  }
}