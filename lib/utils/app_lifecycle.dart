import 'dart:async';

import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/local_notifications/local_notifications_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';

class AppLifecycleUtils{
  static final AppLifecycleUtils _utils=AppLifecycleUtils();
  static AppLifecycleUtils get instance=>_utils;
  Timer? _pausedTimer;
  var _isBack=false;

  addLifecycle(){
    FlutterAppLifecycle.instance.setCallObserver(
      AppStateObserver(call: (back){
        if(back){
          _startPausedTimer();
        }else{
          _checkToLaunchPage();
        }
      })
    );
  }

  _startPausedTimer(){
    _pausedTimer=Timer(const Duration(milliseconds: 3000), () {
      _isBack=true;
    });
  }

  _checkToLaunchPage(){
    PointUtils.instance.session();
    _pausedTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 100),(){
      if(_isBack&&!AdUtils.instance.checkAdShowing()){
        AdUtils.instance.showAd(
          adType: AdType.interstitial,
          adPointId: AdPointId.kwrap_launch,
          closeAd: (){},
          failAd: (){},
        );
      }
      _isBack=false;
    });
  }
}