import 'dart:convert';
import 'dart:math';

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

  List<int> getAmountList()=>_valueBean?.eqRange??[800, 1000, 1500, 2000];

  TixianTask getCashTask(int index){
    try{
      return (_valueBean?.tixianTask??[])[index];
    }catch(e){
      return TixianTask(title: TaskType.quiz,data: 10);
    }
  }

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

  String _getValueStr(){
    var s = valueStr.get();
    if(s.isEmpty){
      return localValueStr.base64();
    }
    return s;
  }
}