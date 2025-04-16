import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_two_step/cash_two_step_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class InputAccountCon extends GetxController{
  var chooseIndex=selectedCashType.get();
  TextEditingController editingController=TextEditingController();
  List<String> cashTypeList=["input_pay","input_cash","input_ama","input_gp","input_web","input_master"];

  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.cash_confirm_pop);
  }

  clickCashType(index){
    if(chooseIndex==index){
      return;
    }
    chooseIndex=index;
    update(["list"]);
  }

  clickCash(int cashNum)async{
    PointUtils.instance.pointEvent(AppPointId.cash_confirm_pop_c);
    var s = editingController.text.toString().trim();
    if(s.isEmpty){
      showToast("Please input your account");
    }

    var success = await CashTaskUtils.instance.createCashTask(chooseIndex, cashNum, s);
    if(!success){
      return;
    }
    BSql.instance.updateUserMoney((-cashNum).toDouble());
    SendEvent(code: EventCode.updateCashList).send();
    QpRouters.back();
    QpRouters.showDialog(
      widget: CashTwoStepDialog(
        cashNum: cashNum,
        cashType: chooseIndex,
      )
    );
  }

  @override
  void onClose() {
    editingController.dispose();
    super.onClose();
  }

}