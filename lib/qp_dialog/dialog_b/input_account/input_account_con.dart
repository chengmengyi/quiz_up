import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/utils.dart';

class InputAccountCon extends GetxController{
  TextEditingController editingController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.cash_confirm_pop);
  }

  clickCash(Function(String account) dismiss){
    PointUtils.instance.pointEvent(AppPointId.cash_confirm_pop_c);
    var s = editingController.text.toString().trim();
    if(s.isEmpty){
      showToast("Please input your account");
    }
    back();
    dismiss.call(s);
  }

  @override
  void onClose() {
    editingController.dispose();
    super.onClose();
  }

}