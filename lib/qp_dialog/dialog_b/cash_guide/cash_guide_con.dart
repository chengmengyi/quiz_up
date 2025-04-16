import 'package:get/get.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class CashGuideCon extends GetxController{
  var cashNum=0,cashType=0;
  NewCashTaskBean? newCashTaskBean;
  @override
  void onReady() {
    super.onReady();
    _queryCashTaskData();
  }

  _queryCashTaskData()async{
    newCashTaskBean = await BSql.instance.queryCashTaskByTypeAndMoney(cashType, cashNum);
    PointUtils.instance.pointEvent(AppPointId.cash_task_pop,data: {"task_from":ValueUtils.instance.getCashTask(newCashTaskBean?.taskIndex??0).title});
    update(["content"]);
  }

  String getTaskIcon(){
    var tixianTask = ValueUtils.instance.getCashTask(newCashTaskBean?.taskIndex??0);
    switch(tixianTask.title){
      case TaskType.quiz: return "cash_quiz";
      case TaskType.box: return "cash_box";
      case TaskType.spin: return "cash_wheel";
      case TaskType.pop: return "cash_pop";
      default: return "cash_pop";
    }
  }

  String getTaskLeftStr(){
    var tixianTask = ValueUtils.instance.getCashTask(newCashTaskBean?.taskIndex??0);
    switch(tixianTask.title){
      case TaskType.quiz: return "Answer ${newCashTaskBean?.totalPro??0} question: ";
      case TaskType.box: return "Open ${newCashTaskBean?.totalPro??0} Gift Box: ";
      case TaskType.spin: return "Play ${newCashTaskBean?.totalPro??0} Spins: ";
      case TaskType.pop: return "Collect ${newCashTaskBean?.totalPro??0} Cash Pops: ";
      default: return "";
    }
  }

  String getProStr()=>"${newCashTaskBean?.currentPro}/${newCashTaskBean?.totalPro}";
}