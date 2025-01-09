import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';

class QpLaunchCon extends GetxController with GetSingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    _initAnimator();
  }

  @override
  void onReady() {
    super.onReady();
    animationController.forward();
  }

  _initAnimator(){
    animationController=AnimationController(duration: const Duration(seconds: 3),vsync: this)
      ..addListener(() {
        update(["progress"]);
      })
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          // offNamed(routersName: QpRouName.aHome);
          offNamed(routersName: QpRouName.bQuiz);
        }
      });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}