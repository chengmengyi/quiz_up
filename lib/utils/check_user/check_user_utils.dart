import 'package:flutter/foundation.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/check_user/check_appsflyer.dart';
import 'package:quiz_up/utils/check_user/check_cloak.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class CheckUserUtils{
  static final CheckUserUtils _utils=CheckUserUtils();
  static CheckUserUtils get instance=>_utils;

  late CheckAppsflyer _checkAppsflyer;
  late CheckCloak _checkCloak;

  var isB=false,launchShow=false,bQuizShow=false;

  initCheck(){
    _checkAppsflyer=CheckAppsflyer();
    _checkAppsflyer.initAppsflyer();

    _checkCloak=CheckCloak();
    _checkCloak.startCheck();
  }

  checkResult(){
    isB=true;
    return;
    if(kDebugMode){
      isB=true;
      return;
    }
    if(localCheckResult.get()){
      isB=true;
      "check user-->local is b".log();
      return;
    }
    if(!_checkCloak.isWhite){
      isB=false;
      "check user-->clock is black".log();
      return;
    }
    if(appsflyerResult.get().isEmpty){
      isB=false;
      "check user-->af is empty".log();
      return;
    }
    isB=true;
    "check user-->is b".log();
    localCheckResult.save(true);
  }

  delayCheckResult(){
    if(!launchShow&&!bQuizShow){
      checkResult();
      if(isB){
        offNamed(routersName: QpRouName.bQuiz);
      }
    }
  }
}