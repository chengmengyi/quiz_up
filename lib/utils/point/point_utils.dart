import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:quiz_up/bean/ad_bean.dart';
import 'package:quiz_up/utils/dio_util.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class PointUtils{
  static final PointUtils _utils=PointUtils();
  static PointUtils get instance=>_utils;

  install()async{
    session();
    if(installEvent.get()){
      return;
    }
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    var copy={
      "concave":referrerMap["build"],
      "lean":referrerMap["referrer_url"],
      "intrigue":referrerMap["install_version"],
      "dyad":referrerMap["user_agent"],
      "sparkle":"concerto",
      "knot":referrerMap["referrer_click_timestamp_seconds"],
      "cypriot":referrerMap["install_begin_timestamp_seconds"],
      "read":referrerMap["referrer_click_timestamp_server_seconds"],
      "scourge":referrerMap["install_begin_timestamp_server_seconds"],
      "warmish":referrerMap["install_first_seconds"],
      "hertzog":referrerMap["last_update_seconds"],
      "deneb":referrerMap["google_play_instant"],
    };
    var map = await _getBaseMap();
    map["copy"]=copy;
    var header = await _getHeaderMap();
    var path = await _getTbaPath();
    "tba---->install-->params:$map".log();
    var result = await BaseDio.instance.requestPost(
      path: path,
      data: map,
      header: header,
    );
    "tba---->install-->result:${result.result}".log();
    if(result.result){
      installEvent.save(true);
    }
  }

  session()async{
    var map = await _getBaseMap();
    map["wick"]= {};
    var header = await _getHeaderMap();
    var path = await _getTbaPath();
    "tba---->session-->params:$map".log();
    var result = await BaseDio.instance.requestPost(
      path: path,
      data: map,
      header: header,
    );
    "tba---->session-->result:${result.result}".log();
  }

  adEvent(MaxAd? ad,AdBean? adBean,AdPointId pointId,{int tryNum=5})async{
    var map = await _getBaseMap();
    map["knockout"]=(ad?.revenue??0)*1000000;
    map["sheathe"]="USD";
    map["bead"]=ad?.networkName??"";
    map["gaylord"]=adBean?.irispgjr??"";
    map["blister"]=adBean?.balemcur??"";
    map["brakeman"]=pointId.name;
    map["fatima"]=adBean?.mtuskwlf??"";
    map["majorca"]=ad?.revenuePrecision??"";
    map["hastings"]="rhenish";
    var header = await _getHeaderMap();
    var path = await _getTbaPath();
    "tba---->ad-->params:$map".log();
    var result = await BaseDio.instance.requestPost(
      path: path,
      data: map,
      header: header,
    );
    "tba---->ad-->result:${result.result}".log();
    if(!result.result){
      if(tryNum>0){
        await Future.delayed(Duration(milliseconds: 2000));
        adEvent(ad, adBean, pointId,tryNum: tryNum-1);
      }else{

      }
    }
  }

  pointEvent(AppPointId appPointId,{Map<String,dynamic>? data,int tryNum=5})async{
    var map = await _getBaseMap();
    map["hastings"]=appPointId.name;
    if(null!=data){
      data.forEach((key,value){
        map["treason<$key"]=value;
      });
    }
    var header = await _getHeaderMap();
    var path = await _getTbaPath();
    "tba---->point-->params:$map".log();
    var result = await BaseDio.instance.requestPost(
      path: path,
      data: map,
      header: header,
    );
    "tba---->point-->result:${result.result}".log();
    if(!result.result){
      if(tryNum>0){
        await Future.delayed(Duration(milliseconds: 2000));
        pointEvent(appPointId,data: data,tryNum: tryNum-1);
      }else{

      }
    }
  }

  Future<String> _getTbaPath()async => "$tbaUrl?lockian=${await FlutterTbaInfo.instance.getBundleId()}&tyrannic=${await FlutterTbaInfo.instance.getBrand()}&width=${await FlutterTbaInfo.instance.getIdfa()}&mast=${await FlutterTbaInfo.instance.getNetworkType()}";

  Future<Map<String,dynamic>> _getHeaderMap()async=>{
    "gideon":DateTime.now().millisecondsSinceEpoch,
    "tyrannic":await FlutterTbaInfo.instance.getBrand(),
  };

  Future<Map<String,dynamic>> _getBaseMap()async{
    var abacus={
      "gideon":DateTime.now().millisecondsSinceEpoch,
      "mast":await FlutterTbaInfo.instance.getNetworkType(),
      "pension":await FlutterTbaInfo.instance.getIdfv(),
      "foxglove":await FlutterTbaInfo.instance.getManufacturer(),
      "prom":await FlutterTbaInfo.instance.getGaid(),
      "lockian":await FlutterTbaInfo.instance.getBundleId(),
    };
    var estrange={
      "pundit":await FlutterTbaInfo.instance.getOperator(),
      "hoopla":await FlutterTbaInfo.instance.getLogId(),
    };
    var perth={
      "tyrannic":await FlutterTbaInfo.instance.getBrand(),
      "durkee":await FlutterTbaInfo.instance.getOsVersion(),
    };
    var facade={
      "width":await FlutterTbaInfo.instance.getIdfa(),
      "stiff":Platform.isAndroid?"seed":"loch",
      "holocene":await FlutterTbaInfo.instance.getAppVersion(),
      "dibble":await FlutterTbaInfo.instance.getOsCountry(),
      "shrill":await FlutterTbaInfo.instance.getSystemLanguage(),
      "bowel":await FlutterTbaInfo.instance.getDeviceModel(),
      "verona":await FlutterTbaInfo.instance.getAndroidId(),
      "sunrise":await FlutterTbaInfo.instance.getDistinctId(),
    };
    return {
      "abacus":abacus,
      "estrange":estrange,
      "perth":perth,
      "facade":facade,
    };
  }
}