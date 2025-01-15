import 'dart:convert';

import 'package:quiz_up/bean/ad_bean.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

abstract class BaseAd{

  List<AdBean> getAdList(String adType,bool one){
    try{
      var json = jsonDecode(_getAdStr());
      List<AdBean> list=[];
      for(var value in json[_getKey(adType, one)]){
        list.add(AdBean.fromJson(value));
      }
      return list;
    }catch(e){
      return [];
    }
  }

  String _getAdStr(){
    var s = adConfig.get();
    if(s.isNotEmpty){
      return s;
    }
    return localAdStr.base64();
  }

  String _getKey(String adType,bool one){
    if(one){
      if(adType==AdType.interstitial){
        return "kwrap_int_one";
      }else{
        return "kwrap_rv_one";
      }
    }else{
      if(adType==AdType.interstitial){
        return "kwrap_int_two";
      }else{
        return "kwrap_rv_two";
      }
    }
  }
}