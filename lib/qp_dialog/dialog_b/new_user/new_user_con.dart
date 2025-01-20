import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class NewUserCon extends GetxController{

  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.quiz_guide_cash_pop);
  }

  clickCash(Function() dismiss){
    PointUtils.instance.pointEvent(AppPointId.quiz_guide_cash_pop_c);
    BSql.instance.updateUserMoney(ValueUtils.instance.getNewUserAdd().toDouble());
    back();
    dismiss.call();
  }
}