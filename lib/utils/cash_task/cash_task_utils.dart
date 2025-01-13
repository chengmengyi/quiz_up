import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class CashTaskUtils{
  static final CashTaskUtils _utils=CashTaskUtils();
  static CashTaskUtils get instance=>_utils;

  createCashTask(int cashType,int cashNum,String account)async{
    await BSql.instance.createCashTaskData(cashType, cashNum, account);
  }

  Future<List<CashAmountBean>> getAmountList(int cashType)async{
    List<CashAmountBean> list=[];
    for(var value in ValueUtils.instance.getAmountList()){
      var taskBean = await BSql.instance.queryCashTask(cashType, value);
      list.add(CashAmountBean(totalMoney: value,cashTaskBean: taskBean));
    }
    return list;
  }

  updateCashTask(String taskType)async{
    await BSql.instance.updateCashTask(taskType);
  }

  updateCashTaskReceived(CashAmountBean amountBean)async{
    await BSql.instance.updateCashTaskReceived(amountBean);
  }
}