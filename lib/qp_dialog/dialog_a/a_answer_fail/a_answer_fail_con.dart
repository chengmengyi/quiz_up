import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class AAnswerFailCon extends GetxController{
  @override
  void onInit() {
    super.onInit();
    ASql.instance.updateUserInfo(UserInfoKey.heart, -1);
  }

  clickAgain(Function(bool again) dismiss){
    back();
    dismiss.call(true);
  }

  clickContinue(Function(bool again) dismiss){
    back();
    dismiss.call(false);
  }
}