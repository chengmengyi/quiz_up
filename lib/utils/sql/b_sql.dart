import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:quiz_up/bean/b_user_info.dart';
import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/bean/cash_task_bean.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/bean/new_user_step_bean.dart';
import 'package:quiz_up/bean/old_user_step_bean.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
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
    if((bUserInfo?.money??0)>0){
      CashTaskUtils.instance.checkShowAccountDialog();
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

  Future<bool> createCashTaskData(int cashType,int cashNum,String account)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ?',whereArgs: [cashType,cashNum]);
    if(list.isNotEmpty){
      showToast("The amount is already being withdrawn");
      return false;
    }
    await db.insert(TableName.newCashTaskB, NewCashTaskBean(cashType: cashType,cashNum: cashNum,taskStep: NewTaskStep.quiz15,currentPro: 0,totalPro: ValueUtils.instance.getCashTask(0).data??10,taskIndex: 0,).toJson());
    _insertCashAccount(account,cashType);
    return true;
  }

  Future<NewCashTaskBean?> queryCashTaskDataByCashStep(int cashType,int cashNum,String taskStep)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ? AND "taskStep" = ?',whereArgs: [cashType,cashNum,taskStep]);
    if(list.isEmpty){
      return null;
    }
    return NewCashTaskBean.fromJson(list.first);
  }

  Future<NewCashTaskBean?> queryCashTaskByTypeAndMoney(int cashType,int cashNum)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ? ',whereArgs: [cashType,cashNum]);
    if(list.isEmpty){
      return null;
    }
    return NewCashTaskBean.fromJson(list.first);
  }

  Future<NewCashTaskBean?> queryCashRankData(int cashType,int cashNum)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ? AND "taskStep" = ?',whereArgs: [cashType,cashNum,NewTaskStep.rank]);
    if(list.isEmpty){
      return null;
    }
    return NewCashTaskBean.fromJson(list.first);
  }

  Future<bool> queryHasCashTask()async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB);
    return list.isNotEmpty;
  }

  updateNewCashQuizOrTask(String taskType)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB);
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var bean = NewCashTaskBean.fromJson(value);
      if(taskType==TaskType.quiz&&bean.taskStep==NewTaskStep.quiz15){
        var nextPro = (bean.currentPro??0)+1;
        if(nextPro>=(bean.totalPro??0)){
          bean.currentPro=ValueUtils.instance.getQueueCurrent()?.intCurrent??99;
          bean.totalPro=ValueUtils.instance.getQueueAll()?.intAll??388;
          bean.taskStep=NewTaskStep.rank;
        }else{
          bean.currentPro=nextPro;
        }
        await db.update(TableName.newCashTaskB, bean.toJson(),where: '"id" = ?', whereArgs: [value["id"]]);
      }else if(bean.taskStep==NewTaskStep.task){
        var tixianTask = ValueUtils.instance.getCashTask(bean.taskIndex??0);
        if(tixianTask.title==taskType){
          var nextPro = (bean.currentPro??0)+1;
          if(nextPro>=(bean.totalPro??0)){
            var newTaskIndex = (bean.taskIndex??0)+1;
            //已完成
            if(newTaskIndex>=ValueUtils.instance.getTiXianTaskLength()){
              bean.currentPro=nextPro;
              bean.taskStep=NewTaskStep.complete;
            }else{
              var cashTask = ValueUtils.instance.getCashTask(newTaskIndex);
              bean.totalPro=cashTask.data;
              bean.currentPro=0;
              bean.taskIndex=newTaskIndex;
            }
          }else{
            bean.currentPro=nextPro;
          }
          await db.update(TableName.newCashTaskB, bean.toJson(),where: '"id" = ?', whereArgs: [value["id"]]);
        }
      }
    }
    SendEvent(code: EventCode.updateCashList).send();
  }

  updateTaskRank(int cashType,int cashNum,Function(int newRankNum,int newRankAllPerson) call)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ? AND "taskStep" = ?',whereArgs: [cashType,cashNum,NewTaskStep.rank]);
    if(list.isEmpty){
      return;
    }
    var intAllDeleteList = ValueUtils.instance.getQueueAll()?.intAllDelete??[1,3];
    var intCurrentDeleteList = ValueUtils.instance.getQueueCurrent()?.intCurrentDelete??[5,8];
    var intAllDelete=0,intCurrentDelete=0;
    if(intAllDeleteList.length<=1){
      intAllDelete=1;
    }else{
      intAllDelete=Random().nextInt(intAllDeleteList.last-intAllDeleteList.first+1)+intAllDeleteList.first;
    }
    if(intCurrentDeleteList.length<=1){
      intCurrentDelete=1;
    }else{
      intCurrentDelete=Random().nextInt(intCurrentDeleteList.last-intCurrentDeleteList.first+1)+intCurrentDeleteList.first;
    }
    var map = list.first;
    var newCashTaskBean = NewCashTaskBean.fromJson(map);
    var currentRankNum = newCashTaskBean.currentPro??0;
    var currentRankAllPerson = newCashTaskBean.totalPro??0;
    var newRankAllPerson = currentRankAllPerson-intAllDelete;
    newCashTaskBean.totalPro=newRankAllPerson;
    var newRankNum = currentRankNum-intCurrentDelete;
    if(newRankNum<=1){
      newRankNum=1;
      newCashTaskBean.currentPro=0;
      newCashTaskBean.taskStep=NewTaskStep.task;
      newCashTaskBean.taskIndex=0;
      newCashTaskBean.totalPro=ValueUtils.instance.getCashTask(0).data??0;
    }else{
      newCashTaskBean.currentPro=newRankNum;
    }
    await db.update(TableName.newCashTaskB, newCashTaskBean.toJson(),where: '"id" = ? ',whereArgs: [map["id"]]);
    SendEvent(code: EventCode.updateCashList).send();
    call.call(newRankNum,newRankAllPerson);
  }

  updateCashTaskReceived(int cashType,int cashNum)async{
    var db = await initDB();
    var list = await db.query(TableName.newCashTaskB,where: '"cashType" = ? AND "cashNum" = ?',whereArgs: [cashType,cashNum]);
    if(list.isEmpty){
      return;
    }
    await db.delete(TableName.newCashTaskB,where: '"id" = ?', whereArgs: [list.first["id"]]);
    SendEvent(code: EventCode.updateCashList).send();
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