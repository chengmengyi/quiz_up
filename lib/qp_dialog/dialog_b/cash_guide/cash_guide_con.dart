import 'package:get/get.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class CashGuideCon extends GetxController{

  String getTaskIcon(NewCashTaskBean? cashTaskBean){
    var tixianTask = ValueUtils.instance.getCashTask(cashTaskBean?.taskIndex??0);
    switch(tixianTask.title){
      case TaskType.quiz: return "cash_quiz";
      case TaskType.box: return "cash_box";
      case TaskType.spin: return "cash_wheel";
      case TaskType.pop: return "cash_pop";
      default: return "cash_pop";
    }
  }

  String getTaskLeftStr(NewCashTaskBean? cashTaskBean){
    var tixianTask = ValueUtils.instance.getCashTask(cashTaskBean?.taskIndex??0);
    switch(tixianTask.title){
      case TaskType.quiz: return "Answer ${cashTaskBean?.totalPro??0} question: ";
      case TaskType.box: return "Open ${cashTaskBean?.totalPro??0} Gift Box: ";
      case TaskType.spin: return "Play ${cashTaskBean?.totalPro??0} Spins: ";
      case TaskType.pop: return "Collect ${cashTaskBean?.totalPro??0} Cash Pops: ";
      default: return "";
    }
  }
}