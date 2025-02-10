import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/local_notifications/local_notifications_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class QpLaunchCon extends GetxController with GetSingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    CheckUserUtils.instance.launchShow=true;
    _initAnimator();
    LocalNotificationsUtils.instance.checkLaunchAppFrom();
  }

  @override
  void onReady() {
    super.onReady();
    animationController.forward();
  }

  _initAnimator()async{
    AppTrackingTransparency.requestTrackingAuthorization();

    animationController=AnimationController(duration: const Duration(seconds: 13),vsync: this)
      ..addListener(() {
        update(["progress"]);
      })
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          CheckUserUtils.instance.checkResult();
          _checkShowAd();
        }
      });
  }

  _checkShowAd(){
    if(CheckUserUtils.instance.isB){
      AdUtils.instance.showAd(
        adType: AdType.interstitial,
        adPointId: AdPointId.kwrap_launch,
        isLaunch: true,
        closeAd: (){
          offNamed(routersName: QpRouName.bQuiz);
        },
        failAd: (){
          offNamed(routersName: QpRouName.bQuiz);
        },
      );
    }else{
      offNamed(routersName: QpRouName.aHome);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
    CheckUserUtils.instance.launchShow=false;
  }
}