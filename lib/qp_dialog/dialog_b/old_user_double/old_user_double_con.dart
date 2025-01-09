import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class OldUserDoubleCon extends GetxController{
  var wheelAddNum=0,signAddNum=ValueUtils.instance.getSignAddNum();

  

  clickClose(){
    back();
  }
}