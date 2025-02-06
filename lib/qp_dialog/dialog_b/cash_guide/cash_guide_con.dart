import 'package:get/get.dart';
import 'package:quiz_up/bean/cash_task_bean.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';

class CashGuideCon extends GetxController{

  String getTaskIcon(CashTaskBean? cashTaskBean){
    switch(cashTaskBean?.taskType){
      case TaskType.quiz: return "cash_quiz";
      case TaskType.box: return "cash_box";
      case TaskType.spin: return "cash_wheel";
      case TaskType.pop: return "cash_pop";
      default: return "cash_pop";
    }
  }

  String getTaskLeftStr(CashTaskBean? cashTaskBean){
    switch(cashTaskBean?.taskType){
      case TaskType.quiz: return "Answer ${cashTaskBean?.totalPro??0} question: ";
      case TaskType.box: return "Open ${cashTaskBean?.totalPro??0} Gift Box: ";
      case TaskType.spin: return "Play ${cashTaskBean?.totalPro??0} Spins: ";
      case TaskType.pop: return "Collect ${cashTaskBean?.totalPro??0} Cash Pops: ";
      default: return "";
    }
  }
}