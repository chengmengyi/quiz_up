import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/input_account/input_account_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class CashTaskUtils{
  static final CashTaskUtils _utils=CashTaskUtils();
  static CashTaskUtils get instance=>_utils;

  checkShowAccountDialog()async{
    var amountList = ValueUtils.instance.getAmountList();
    if((BSql.instance.bUserInfo?.money??0)<amountList.first){
      return;
    }
    var has = await BSql.instance.queryHasCashTask();
    if(has){
      return;
    }
    QpRouters.showDialog(
      widget: InputAccountDialog(
        cashNum: amountList.first,
        dismiss: (account)async{

        },
      ),
    );
  }

  Future<bool> createCashTask(int cashType,int cashNum,String account)async{
    return await BSql.instance.createCashTaskData(cashType, cashNum, account);
  }

  Future<List<CashAmountBean>> getAmountList(int cashType)async{
    List<CashAmountBean> list=[];
    for(var value in ValueUtils.instance.getAmountList()){
      var taskBean = await BSql.instance.queryCashTaskByTypeAndMoney(cashType, value);
      list.add(CashAmountBean(totalMoney: value,cashTaskBean: taskBean));
    }
    return list;
  }

  updateCashTask(String taskType)async{
    await BSql.instance.updateNewCashQuizOrTask(taskType);
  }
}