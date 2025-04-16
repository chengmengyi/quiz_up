import 'package:get/get.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class CashTwoStepCon extends GetxController{
  var cashNum=0,cashType=0;
  NewCashTaskBean? cashTaskBean;
  List<String> cashTypeList=["two_pay","two_cash","two_ama","two_gp","two_web","two_master"];
  @override
  void onReady() {
    super.onReady();
    _queryData();
  }

  _queryData()async{
    cashTaskBean = await BSql.instance.queryCashTaskDataByCashStep(cashType, cashNum, NewTaskStep.quiz15);
    update(["progress"]);
  }

  clickBtn(){
    offAllUntilHome();
  }

  String getProStr()=>"${cashTaskBean?.currentPro??0}/${cashTaskBean?.totalPro??15}";

  double getPro(){
    var totalPro = cashTaskBean?.totalPro??15;
    if(totalPro<=0){
      return 0.0;
    }
    var d = (cashTaskBean?.currentPro??0)/totalPro;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }else{
      return d;
    }
  }
}