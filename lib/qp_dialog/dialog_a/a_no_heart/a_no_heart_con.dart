import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class ANoHeartCon extends GetxController{

  clickSpend()async{
    await ASql.instance.updateUserInfo(UserInfoKey.coin, -50);
    await ASql.instance.updateUserInfo(UserInfoKey.heart, 3);
    back();
  }
}