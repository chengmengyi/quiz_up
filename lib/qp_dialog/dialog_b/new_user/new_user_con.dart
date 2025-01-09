import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class NewUserCon extends GetxController{

  clickCash(Function() dismiss){
    BSql.instance.updateUserMoney(ValueUtils.instance.getNewUserAdd().toDouble());
    back();
    dismiss.call();
  }
}