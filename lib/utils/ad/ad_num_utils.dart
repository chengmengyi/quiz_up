import 'dart:convert';

import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class AdNumUtils{
  static final AdNumUtils _utils=AdNumUtils();
  static AdNumUtils get instance=>_utils;

  var _maxShow=100,_maxClick=100,_todayShow=0,_todayClick=0;

  initMaxNum(){
    _todayShow=getTodayNum(todayShowAdNum.get());
    _todayClick=getTodayNum(todayClickAdNum.get());
    try{
      var json = jsonDecode(localAdStr.base64());
      _maxShow = json["obfhskra"];
      _maxClick = json["lecaovsp"];
    }catch(e){

    }
  }

  bool notLoadAd() => _todayShow>=_maxShow||_todayClick>=_maxClick;

  updateTodayShow(){
    _todayShow++;
    todayShowAdNum.save("${getTodayTime()}_$_todayShow");
  }

  updateTodayClick(){
    _todayClick++;
    todayClickAdNum.save("${getTodayTime()}_$_todayClick");
  }
}