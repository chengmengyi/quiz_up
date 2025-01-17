import 'package:decimal/decimal.dart';
import 'package:quiz_up/bean/b_user_info.dart';
import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/bean/cash_task_bean.dart';
import 'package:quiz_up/bean/new_user_step_bean.dart';
import 'package:quiz_up/bean/old_user_step_bean.dart';
import 'package:quiz_up/utils/cash_task/task_status.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/base_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BSql extends BaseSql{
  static final BSql _sql=BSql();
  static BSql get instance  => _sql;

  BUserInfo? bUserInfo;

  queryUserInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoB);
    if(list.isEmpty){
      bUserInfo=BUserInfo(money: 0.0, answerRightNum: 0, answerNum: 0, answerIndex: 0);
      var id = await db.insert(TableName.userInfoB, bUserInfo?.toJson()??{});
      bUserInfo?.id=id;
      return;
    }
    bUserInfo = BUserInfo.fromJson(list.first);
  }

  updateUserMoney(double addNum)async{
    var d = Decimal.parse("$addNum")+Decimal.parse("${bUserInfo?.money??0.0}");
    bUserInfo?.money=d.toDouble();
    var moneyLevel = lastMoneyLevel.get()+100;
    if((bUserInfo?.money??0)>=moneyLevel){
      PointUtils.instance.pointEvent(AppPointId.cash_money_detail,data: {"money_from":moneyLevel});
      lastMoneyLevel.save(moneyLevel);
    }
    await updateUserInfo();
    SendEvent(code: EventCode.showMoneyLottie).send();
  }

  updateUserAnswerNum(bool right)async{
    bUserInfo?.answerNum=(bUserInfo?.answerNum??0)+1;
    bUserInfo?.answerIndex=(bUserInfo?.answerIndex??0)+1;
    if(right){
      bUserInfo?.answerRightNum=(bUserInfo?.answerRightNum??0)+1;
    }
    await updateUserInfo();
    SendEvent(code: EventCode.updateUserAnswerNum).send();
  }

  updateUserInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoB);
    if(list.isEmpty){
      return;
    }
    await db.update(TableName.userInfoB, bUserInfo?.toJson()??{},where: '"id" = ?', whereArgs: [bUserInfo?.id]);
  }

  Future<NewUserStepBean> queryNewGuideInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.newUserGuideB);
    if(list.isEmpty){
      var stepBean = NewUserStepBean(newUserStep: NewUserStep.showRightAnswerFinger);
      var id = await db.insert(TableName.newUserGuideB, stepBean.toJson());
      stepBean.id=id;
      return stepBean;
    }
    return NewUserStepBean.fromJson(list.first);
  }

  updateNewUserStep(NewUserStepBean? bean)async{
    var db = await initDB();
    db.update(TableName.newUserGuideB, bean?.toJson()??{},where: '"id" = ?', whereArgs: [bean?.id]);
  }

  Future<OldUserStepBean> queryOldGuideInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.oldUserGuideB,where: '"stepTimer" = ?', whereArgs: [getTodayTime()]);
    if(list.isEmpty){
      var stepBean = OldUserStepBean(oldUserStep: OldUserStep.showOldUserDialog,stepTimer: getTodayTime());
      var id = await db.insert(TableName.oldUserGuideB, stepBean.toJson());
      stepBean.id=id;
      return stepBean;
    }
    return OldUserStepBean.fromJson(list.first);
  }

  updateOldUserStep(OldUserStepBean? bean)async{
    var db = await initDB();
    db.update(TableName.oldUserGuideB, bean?.toJson()??{},where: '"id" = ?', whereArgs: [bean?.id]);
  }

  Future<List<int>> queryReceivedIndexList()async{
    var db = await initDB();
    var list = await db.query(TableName.receivedIndexB);
    if(list.isEmpty){
      return [];
    }
    List<int> result=[];
    for (var value in list) {
      result.add(value["receivedIndex"] as int);
    }
    return result;
  }

  updateReceivedIndex(int index)async{
    var db = await initDB();
    var list = await db.query(TableName.receivedIndexB,where: '"receivedIndex" = ? ',whereArgs: [index]);
    if(list.isNotEmpty){
      return;
    }
    await db.insert(TableName.receivedIndexB, {"receivedIndex":index});
  }

  createCashTaskData(int cashType,int cashNum,String account)async{
    var db = await initDB();
    var list = await db.query(TableName.cashTaskB,where: '"cashType" = ? AND "cashNum" = ?',whereArgs: [cashType,cashNum]);
    if(list.isNotEmpty){
      return;
    }
    await db.insert(TableName.cashTaskB, CashTaskBean(cashType: cashType,cashNum: cashNum,taskType: TaskType.quiz,currentPro: 0,totalPro: ValueUtils.instance.getCashTask(0).data??10,taskIndex: 0,taskStatus: TaskStatus.processing).toJson());
    _insertCashAccount(account,cashType);
  }

  Future<CashTaskBean?> queryCashTask(int cashType,int cashNum)async{
    var db = await initDB();
    var list = await db.query(TableName.cashTaskB,where: '"cashType" = ? AND "cashNum" = ? ',whereArgs: [cashType,cashNum]);
    if(list.isEmpty){
      return null;
    }
    return CashTaskBean.fromJson(list.first);
  }

  updateCashTask(String taskType)async{
    var db = await initDB();
    var list = await db.query(TableName.cashTaskB,where: '"taskType" = ? AND "taskStatus" = ?',whereArgs: [taskType,TaskStatus.processing]);
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var bean = CashTaskBean.fromJson(value);
      bean.currentPro=(bean.currentPro??0)+1;
      if((bean.currentPro??0)>=(bean.totalPro??0)){
        var newTaskIndex = (bean.taskIndex??0)+1;
        //已完成
        if(newTaskIndex>=ValueUtils.instance.getTiXianTaskLength()){
          bean.taskStatus=TaskStatus.completed;
        }else{
          var cashTask = ValueUtils.instance.getCashTask(newTaskIndex);
          bean.taskType=cashTask.title;
          bean.totalPro=cashTask.data;
          bean.currentPro=0;
          bean.taskIndex=newTaskIndex;
        }
      }
      await db.update(TableName.cashTaskB, bean.toJson(),where: '"id" = ?', whereArgs: [value["id"]]);
    }
  }

  updateCashTaskReceived(CashAmountBean amountBean)async{
    var db = await initDB();
    var list = await db.query(TableName.cashTaskB,where: '"cashType" = ? AND "cashNum" = ?',whereArgs: [amountBean.cashTaskBean?.cashType,amountBean.totalMoney??0]);
    if(list.isEmpty){
      return;
    }
    await db.delete(TableName.cashTaskB,where: '"id" = ?', whereArgs: [list.first["id"]]);
  }

  _insertCashAccount(String account,int cashType)async{
    var db = await initDB();
    var list = await db.query(TableName.cashAccountB,where: '"cashType" = ?',whereArgs: [cashType]);
    if(list.isEmpty){
      await db.insert(TableName.cashAccountB, {"cashAccount":account,"cashType":cashType});
    }
  }

  Future<String> queryCashAccount(int cashType)async{
    var db = await initDB();
    var list = await db.query(TableName.cashAccountB,where: '"cashType" = ?',whereArgs: [cashType]);
    if(list.isEmpty){
      return "";
    }
    return list.first["cashAccount"] as String;
  }
}