import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_bean.dart';

class ValueUtils{
  static final ValueUtils _utils=ValueUtils();
  static ValueUtils get instance=>_utils;

  ValueBean? _valueBean;

  initValue(){
    _valueBean=ValueBean.fromJson(jsonDecode(_getValueStr()));
  }

  int getNewUserAdd()=>_valueBean?.newPrize??134;

  double getSignAddNum()=> _getRewardByList(_valueBean?.checkPrize??[]);

  double getQuizAddNum()=> _getRewardByList(_valueBean?.quizPrize??[]);

  double getBubbleAddNum()=> _getRewardByList(_valueBean?.floatPrize??[]);

  double getBoxAddNum()=> _getRewardByList(_valueBean?.boxPrize??[]);

  List<int> getAmountList()=>_valueBean?.eqRange??[800, 1000, 1500, 2000];

  int getMaxCashNum(){
    var money = BSql.instance.bUserInfo?.money??0.0;
    var list = getAmountList();
    if(money>=list.last){
      return list.last;
    }
    for (var value in list) {
      if(money<=value){
        return value;
      }
    }
    return 0;
  }

  double getEarnNum(){
    var cashNum = getMaxCashNum();
    var money = BSql.instance.bUserInfo?.money??0.0;
    var d = (Decimal.fromInt(cashNum)-Decimal.parse("$money")).toDouble();
    if(d<=0){
      return 0;
    }
    return d;
  }

  bool checkShowAd(String adType){
    if(kDebugMode){
      return false;
    }
    var list = (adType==AdType.interstitial?_valueBean?.intadPoint:_valueBean?.rvadPoint)??[];
    if(list.isEmpty){
      return false;
    }
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    if(answerNum>=(list.last.endNumber??0)){
      return Random().nextInt(100)<(list.last.point??0);
    }
    for (var value in list) {
      if(answerNum>=(value.firstNumber??0)&&answerNum<(value.endNumber??0)){
        return Random().nextInt(100)<(value.point??0);
      }
    }
    return false;
  }

  bool checkShowRewardNextIntAd(){
    if(kDebugMode){
      return false;
    }
    var list = _valueBean?.intPopAd??[];
    if(list.isEmpty){
      return false;
    }
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    if(answerNum>=(list.last.endNumber??0)){
      return Random().nextInt(100)<(list.last.point??0);
    }
    for (var value in list) {
      if(answerNum>=(value.firstNumber??0)&&answerNum<(value.endNumber??0)){
        return Random().nextInt(100)<(value.point??0);
      }
    }
    return false;
  }

  TixianTask getCashTask(int index){
    try{
      return (_valueBean?.tixianTask??[])[index];
    }catch(e){
      return TixianTask(title: TaskType.quiz,data: 10);
    }
  }

  int getTiXianTaskLength()=>(_valueBean?.tixianTask??[]).length;

  double _getRewardByList(List<QuizPrize> list){
    if(list.isEmpty){
      return 5.0;
    }
    var money = BSql.instance.bUserInfo?.money??0.0;
    if(money>=(list.last.endNumber??800)){
      return _randomMinMax(list.last.prize?.first??5, list.last.prize?.last??10);
    }
    for (var value in list) {
      if(money>=(value.firstNumber??0)&&money<(value.endNumber??0)){
        return _randomMinMax(value.prize?.first??5, value.prize?.last??10);
      }
    }
    return 5.0;
  }

  int getBoxMaxAddNum(){
    var list = _valueBean?.boxPrize??[];
    if(list.isEmpty){
      return 5;
    }
    var money = BSql.instance.bUserInfo?.money??0.0;
    if(money>=(list.last.endNumber??800)){
      var list2 = list.last.prize??[];
      if(list2.isEmpty){
        return 5;
      }
      return list2.last;
    }
    for (var value in list) {
      if(money>=(value.firstNumber??0)&&money<(value.endNumber??0)){
        var list2 = value.prize??[];
        if(list2.isEmpty){
          return 5;
        }
        return list2.last;
      }
    }
    return 5;
  }

  double _randomMinMax(int min,int max)=>(Random().nextDouble()*(max-min)+min).toStringAsFixed(2).toDou();

  int getWheelAddNum(){
    var point5 = _valueBean?.wheel?.point5??10;
    var point10 = _valueBean?.wheel?.point10??80;
    var point20 = _valueBean?.wheel?.point20??5;
    var point50 = _valueBean?.wheel?.point50??4;
    var point80 = _valueBean?.wheel?.point80??1;
    var i = Random().nextInt(100);
    if(i<point5){
      return 5;
    }else if(i>=point5&&i<(point5+point10)){
      return 10;
    }else if(i>=(point5+point10)&&i<(point5+point10+point20)){
      return 20;
    }else if(i>=(point5+point10+point20)&&i<(point5+point10+point20+point50)){
      return 50;
    }else{
      return 80;
    }
  }

  QueueAll? getQueueAll()=>_valueBean?.queueAll;

  QueueCurrent? getQueueCurrent()=>_valueBean?.queueCurrent;

  String _getValueStr(){
    if(kDebugMode){
      return localValueStr.base64();
    }
    var s = valueConfig.get();
    if(s.isEmpty){
      return localValueStr.base64();
    }
    return s;
  }
}