import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/bean/cash_type_bean.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_guide/cash_guide_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_rank/cash_rank_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_success/cahs_success_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_two_step/cash_two_step_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/input_account/input_account_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/no_money/no_money_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BCashCon extends GetxController implements EventListener{
  var cashIndex=0;
  List<CashTypeBean> cashTypeList=[];
  List<CashAmountBean> amountList=[];
  late ReceiveEvent receiveEvent;
  
  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.cash_page);
    receiveEvent=ReceiveEvent(eventListener: this);
    _checkFromNewUser();
    _initCashTypeList();
  }

  @override
  void onReady() {
    super.onReady();
    _initAmountList();
  }

  clickCashType(index){
    cashIndex=index;
    selectedCashType.save(index);
    update(["cash_type","money_bg"]);
    _initAmountList();
  }

  clickCash(index)async{
    PointUtils.instance.pointEvent(AppPointId.cash_page_c);
    var amountBean = amountList[index];

    if(null!=amountBean.cashTaskBean){
      switch(amountBean.cashTaskBean?.taskStep){
        case NewTaskStep.quiz15:
          QpRouters.showDialog(widget: CashTwoStepDialog(cashNum: amountBean.totalMoney, cashType: cashIndex));
          break;
        case NewTaskStep.rank:
          QpRouters.showDialog(widget: CashRankDialog(cashNum: amountBean.totalMoney, cashType: cashIndex));
          break;
        case NewTaskStep.task:
          QpRouters.showDialog(widget: CashGuideDialog(cashNum: amountBean.totalMoney, cashType: cashIndex));
          break;
        case NewTaskStep.complete:
          PointUtils.instance.pointEvent(AppPointId.cash_suc_pop_c);
          QpRouters.showDialog(widget: CashSuccessDialog(cashNum: amountBean.totalMoney, cashType: cashIndex));
          break;
      }
      return;
    }
    var money = BSql.instance.bUserInfo?.money??0;
    var totalMoney = amountBean.totalMoney;
    if(money<totalMoney){
      QpRouters.showDialog(widget: NoMoneyDialog());
      return;
    }
    var account = await BSql.instance.queryCashAccount(cashIndex);
    if(account.isNotEmpty){
      await CashTaskUtils.instance.createCashTask(cashIndex, totalMoney, account);
      BSql.instance.updateUserMoney((-totalMoney).toDouble());
      _initAmountList();
      return;
    }
    QpRouters.showDialog(
      widget: InputAccountDialog(
        cashNum: totalMoney,
        dismiss: (account)async{

        },
      )
    );
  }

  _checkFromNewUser(){
    var map = Get.arguments;
    if(null!=map&&map["fromNewUser"]==true){
      // GuideUtils.instance.updateNewUserStep(NewUserStep.newUserGuideCompleted);
    }
  }
  
  _initCashTypeList(){
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_pay", smallIcon: "cash_type_small_pay"));
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_cash", smallIcon: "cash_type_small_cash"));
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_ama", smallIcon: "cash_type_small_ama"));
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_gp", smallIcon: "cash_type_small_gp"));
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_web", smallIcon: "cash_type_small_web"));
    cashTypeList.add(CashTypeBean(largeIcon: "cash_type_large_master", smallIcon: "cash_type_small_master"));
  }

  _initAmountList()async{
    amountList.clear();
    amountList.addAll(await CashTaskUtils.instance.getAmountList(cashIndex));
    update(["amount"]);
  }

  double getMoneyPro(int money){
    if(money<=0){
      return 0.0;
    }
    var d = (BSql.instance.bUserInfo?.money??0)/money;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }else{
      return d;
    }
  }

  String getMoneyProStr(int money){
    if(money<=0){
      return "0%";
    }
    var d = (BSql.instance.bUserInfo?.money??0)*100~/money;
    if(d>=100){
      d=100;
    }
    return "$d%";
  }

  String getCashTaskProLeftStr(NewCashTaskBean? cashTaskBean){
    if(cashTaskBean?.taskStep==NewTaskStep.quiz15){
      return "Answer";
    }else if(cashTaskBean?.taskStep==NewTaskStep.rank){
      return "Current ranking";
    }else{
      var tixianTask = ValueUtils.instance.getCashTask(cashTaskBean?.taskIndex??0);
      switch(tixianTask.title){
        case TaskType.quiz: return "Answer";
        case TaskType.box: return "Open";
        case TaskType.spin: return "Play";
        case TaskType.pop: return "Collect";
        default: return "";
      }
    }

  }

  String getCashTaskProRightStr(NewCashTaskBean? cashTaskBean){
    if(cashTaskBean?.taskStep==NewTaskStep.quiz15){
      return "question";
    }else if(cashTaskBean?.taskStep==NewTaskStep.rank){
      return "";
    }else{
      var tixianTask = ValueUtils.instance.getCashTask(cashTaskBean?.taskIndex??0);
      switch(tixianTask.title){
        case TaskType.quiz: return "question";
        case TaskType.box: return "Gift Box";
        case TaskType.spin: return "Spins";
        case TaskType.pop: return "Cash Pops";
        default: return "";
      }
    }
  }

  String getTaskIcon(NewCashTaskBean? cashTaskBean){
    if(cashTaskBean?.taskStep==NewTaskStep.quiz15){
      return "task_question";
    }else if(cashTaskBean?.taskStep==NewTaskStep.rank){
      return "icon_video";
    }else{
      var tixianTask = ValueUtils.instance.getCashTask(cashTaskBean?.taskIndex??0);
      switch(tixianTask.title){
        case TaskType.quiz: return "task_question";
        case TaskType.box: return "task_box";
        case TaskType.spin: return "task_spin";
        case TaskType.pop: return "task_pop";
        default: return "task_pop";
      }
    }
  }

  String getMoneyBg(){
    switch(cashIndex){
      case 0: return "cash_bg_pay";
      case 1: return "cash_bg_cash";
      case 2: return "cash_bg_ama";
      case 3: return "cash_bg_gp";
      case 4: return "cash_bg_web";
      case 5: return "cash_bg_master";
      default: return "cash_bg_pay";
    }
  }

  @override
  receivedEvent(SendEvent event) {
    switch(event.code){
      case EventCode.updateUserMoney:
        update(["money"]);
        break;
      case EventCode.updateCashList:
        _initAmountList();
        break;
    }
  }

  clickClose(){
    PointUtils.instance.pointEvent(AppPointId.quiz_page);
    QpRouters.back(result: {});
  }

  test(){
    if(!kDebugMode){
      return;
    }

  }

  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}