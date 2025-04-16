import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class CashSuccessCon extends GetxController{
  List<String> cashTypeList=["two_pay","two_cash","two_ama","two_gp","two_web","two_master"];

  clickBtn(int cashType,int cashNum)async{
    await BSql.instance.updateCashTaskReceived(cashType, cashNum);
    QpRouters.back();
  }
}