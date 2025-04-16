import 'package:quiz_up/bean/cash_task_bean.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';

class CashAmountBean{
  int totalMoney;
  NewCashTaskBean? cashTaskBean;
  CashAmountBean({required this.totalMoney,this.cashTaskBean});
}