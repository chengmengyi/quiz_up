import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/dio_util.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/utils.dart';

class CheckCloak{
  var _requestNum=0,isWhite=false;

  startCheck()async{
    PointUtils.instance.pointEvent(AppPointId.cloak_req);
    var bundleId = await FlutterTbaInfo.instance.getBundleId();
    var os = Platform.isAndroid?"seed":"loch";
    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var deviceModel = await FlutterTbaInfo.instance.getDeviceModel();
    var time = DateTime.now().millisecondsSinceEpoch;
    var osVersion = await FlutterTbaInfo.instance.getOsVersion();
    var gaid = await FlutterTbaInfo.instance.getGaid();
    var androidId = await FlutterTbaInfo.instance.getAndroidId();
    var brand = await FlutterTbaInfo.instance.getBrand();
    "check user-->start request cloak".log();
    var dioResult = await BaseDio.instance.requestPost(
      path: cloakUrl,
      data: {
        "lockian":bundleId,
        "stiff":os,
        "holocene":appVersion,
        "sunrise":distinctId,
        "gideon":time,
        "bowel":deviceModel,
        "durkee":osVersion,
        "prom":gaid,
        "verona":androidId,
        "tyrannic":brand,
      },
    );
    "check user-->request cloak result:${dioResult.result}--->${dioResult.msg}".log();
    if(dioResult.result){
      isWhite=dioResult.msg=="electron";
      PointUtils.instance.pointEvent(AppPointId.cloak_suc,data: {"cloak_user":isWhite?1:0});
      CheckUserUtils.instance.delayCheckResult();
    }else{
      await Future.delayed(Duration(milliseconds: 2000));
      _requestNum++;
      startCheck();
      // if(_requestNum<20){
      //   await Future.delayed(Duration(milliseconds: 2000));
      //   _requestNum++;
      //   startCheck();
      // }
    }
  }
}