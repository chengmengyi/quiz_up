import 'dart:math';

import 'package:get/get.dart';
import 'package:quiz_up/bean/new_cash_task_bean.dart';
import 'package:quiz_up/bean/rank_list_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_guide/cash_guide_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class CashRankCon extends GetxController{
  var cashNum=0,cashType=0;
  NewCashTaskBean? newCashTaskBean;
  List<String> cashTypeList=["two_pay","two_cash","two_ama","two_gp","two_web","two_master"];
  List<RankListBean> rankList=[];

  @override
  void onReady() {
    super.onReady();
    _getCashData();
  }

  clickBtn()async{
    if((newCashTaskBean?.currentPro??0)<=1){
      QpRouters.back();
      QpRouters.showDialog(
        widget: CashGuideDialog(cashNum: cashNum, cashType: cashType),
      );
      return;
    }
    // AdUtils.instance.showTaskAd(
    //   closeAd: ()async{
    //     await BSql.instance.updateTaskRank(cashType, cashNum);
    //     _getCashData();
    //   },
    // );

    _closeAd();
  }

  _closeAd(){
    BSql.instance.updateTaskRank(cashType, cashNum, (int newRankNum,int newRankAllPerson){
      showToast("Your Current rank：$newRankNum");
      if(newRankNum<=1){
        newCashTaskBean?.currentPro=newRankNum;
        newCashTaskBean?.totalPro=newRankAllPerson;
        _initList(newRankAllPerson);
        return;
      }
      _getCashData();
      },
    );
  }

  _getCashData()async{
    newCashTaskBean = await BSql.instance.queryCashRankData(cashType, cashNum);
    var rankAllPerson = newCashTaskBean?.totalPro??0;
   _initList(rankAllPerson);
  }

  _initList(int rankAllPerson)async{
    var account = await BSql.instance.queryCashAccount(cashType);
    rankList.clear();
    var phoneNum = rankAllPerson~/2;
    var emailNum = rankAllPerson-phoneNum-1;
    List<String> phoneAndEmailList=_generateRandomPhoneNumbers(phoneNum)+_generateRandomEmails(emailNum);
    for (int i = 0; i < phoneAndEmailList.length; i++) {
      rankList.add(RankListBean(id: "${i+1}", account: phoneAndEmailList[i], amount: "${ValueUtils.instance.getAmountList().random()}"));
    }
    var myRankNum = newCashTaskBean?.currentPro??0;
    var index = myRankNum<=1?1:myRankNum-1;
    rankList.removeAt(index);
    rankList.insert(index, RankListBean(id: "${myRankNum+1}", account: account, amount: "$cashNum"));
    update(["rank"]);
  }

  List<String> _generateRandomPhoneNumbers(int count) {
    List<String> phoneNumbers = [];
    List<String> prefixes = ['13', '14', '15', '16', '17', '18', '19'];
    Random random = Random();
    for (int i = 0; i < count; i++) {
      String prefix = prefixes[random.nextInt(prefixes.length)];
      String number = '';
      for (int j = 0; j < 9; j++) {
        number += random.nextInt(10).toString();
      }
      phoneNumbers.add(prefix + number);
    }
    return phoneNumbers;
  }


  List<String> _generateRandomEmails(int count) {
    List<String> emails = [];
    List<String> domains = ['gmail.com', 'yahoo.com', 'hotmail.com', '163.com', 'qq.com'];
    Random random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    for (int i = 0; i < count; i++) {
      String username = '';
      int length = random.nextInt(6) + 3; // 用户名长度为 3 - 8 位
      for (int j = 0; j < length; j++) {
        username += chars[random.nextInt(chars.length)];
      }
      String domain = domains[random.nextInt(domains.length)];
      emails.add('$username@$domain');
    }
    return emails;
  }

  String hideAccount(String account){
    if(account.length<=1){
      return "*";
    }
    if(account.length<=8){
      String star="";
      for (int i = 0; i < account.length-1; i++) {
        star="$star*";
      }
      return "${account.substring(0,1)}$star";
    }
    var s = account.substring(account.length-8,account.length);
    String star="";
    for (int i = 0; i < 4; i++) {
      star="$star*";
    }
    return "${account.substring(0,1)}$star$s";
  }
}