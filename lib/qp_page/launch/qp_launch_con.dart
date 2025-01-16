import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/local_notifications/local_notifications_utils.dart';

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

  _initAnimator(){
    animationController=AnimationController(duration: const Duration(seconds: 13),vsync: this)
      ..addListener(() {
        update(["progress"]);
      })
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          CheckUserUtils.instance.checkResult();
          offNamed(routersName: CheckUserUtils.instance.isB?QpRouName.bQuiz:QpRouName.aHome);
        }
      });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
    CheckUserUtils.instance.launchShow=false;
  }
}