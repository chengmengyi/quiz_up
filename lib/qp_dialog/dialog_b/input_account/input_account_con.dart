import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/utils.dart';

class InputAccountCon extends GetxController{
  TextEditingController editingController=TextEditingController();

  clickCash(Function(String account) dismiss){
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