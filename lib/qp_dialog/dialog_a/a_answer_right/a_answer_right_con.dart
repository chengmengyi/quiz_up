import 'dart:math';

import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class AAnswerRightCon extends GetxController{
  var addReward=0;

  @override
  void onInit() {
    super.onInit();
    addReward=200+Random().nextInt(100);
  }

  clickReward(Function() dismiss){
    ASql.instance.updateUserInfo(UserInfoKey.coin,addReward);
    QpRouters.back();
    dismiss.call();
  }
}