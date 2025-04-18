import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/launch/qp_launch_pa.dart';
import 'package:quiz_up/qp_page/qp_a/a_home/a_home_pa.dart';
import 'package:quiz_up/qp_page/qp_a/a_question/a_question_page.dart';
import 'package:quiz_up/qp_page/qp_a/a_wheel/a_wheel_page.dart';
import 'package:quiz_up/qp_page/qp_b/b_cash/b_cash_page.dart';
import 'package:quiz_up/qp_page/qp_b/b_h5_ad/h5_ad_page.dart';
import 'package:quiz_up/qp_page/qp_b/b_quiz/b_quiz_page.dart';
import 'package:quiz_up/qp_page/qp_wwwwbbbb/privacy_page.dart';
import 'package:quiz_up/qp_page/setting/setting_page.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';

final pageList=[
  GetPage(
      name: QpRouName.launch,
      page: ()=> QpLaunchPa(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.aHome,
      page: ()=> AHomePa(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.aQuestion,
      page: ()=> AQuestionPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.aWheel,
      page: ()=> AWheelPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.setting,
      page: ()=> SettingPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.web,
      page: ()=> QpWWWWWPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.bQuiz,
      page: ()=> BQuizPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.bCash,
      page: ()=> BCashPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: QpRouName.bH5Ad,
      page: ()=> H5AdPage(),
      transition: Transition.fadeIn
  ),
];

class QpRouters{

  static toNamed({required String routersName,Map<String, dynamic>? arguments,Function(Map<String,dynamic>)? backCall})async{
    var result=await Get.toNamed(routersName,arguments: arguments);
    if(null!=result&&null!=backCall){
      backCall.call(result);
    }
  }

  static offNamed({required String routersName,Map<String, dynamic>? arguments}){
    Get.offNamed(routersName,arguments: arguments);
  }

  static offAllUntilHome(){
    Get.until((route)=>route.settings.name==QpRouName.bQuiz);
  }

  static back({Map<String, dynamic>? result}){
    Get.back(result: result);
  }

  static Map<String, dynamic> getArguments() {
    try {
      return Get.arguments as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  static showDialog({required Widget widget,bool useSafeArea=true,Color? barrierColor}){
    Get.dialog(
      widget,
      useSafeArea: useSafeArea,
      // arguments: arguments,
      barrierColor: barrierColor,
      barrierDismissible: false,
    );
  }
}

// toNamed({required String routersName,Map<String, dynamic>? arguments,Function(Map<String,dynamic>)? backCall})async{
//   var result=await Get.toNamed(routersName,arguments: arguments);
//   if(null!=result&&null!=backCall){
//     backCall.call(result);
//   }
// }
//
// offNamed({required String routersName,Map<String, dynamic>? arguments}){
//   Get.offNamed(routersName,arguments: arguments);
// }
//
// offAllUntilHome(){
//   Get.until((route)=>route.settings.name==QpRouName.bQuiz);
// }
//
// back({Map<String, dynamic>? result}){
//   Get.back(result: result);
// }
//
// Map<String, dynamic> getArguments() {
//   try {
//     return Get.arguments as Map<String, dynamic>;
//   } catch (e) {
//     return {};
//   }
// }
//
// showDialog({required Widget widget,bool useSafeArea=true,Color? barrierColor}){
//   Get.dialog(
//     widget,
//     useSafeArea: useSafeArea,
//     // arguments: arguments,
//     barrierColor: barrierColor,
//     barrierDismissible: false,
//   );
// }
