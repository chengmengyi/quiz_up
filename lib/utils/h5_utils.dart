import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class H5Utils{
  static final H5Utils _utils=H5Utils();
  static H5Utils get instance=>_utils;

  static const MethodChannel _quizChannel = MethodChannel('com.quizup.find.rightanswer.h5');
  initChannel(BuildContext context){
    _quizChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'quiz_h5_method') {
        var data = call.arguments;
        if (data != null) {
          double? quizX = double.tryParse('${data['quizX']}');
          double? quizY = double.tryParse('${data['quizY']}');
          if (quizX != null && quizY != null) {
            Offset flutterCoordinates = Offset(quizX, quizY);
            RenderBox? renderBox = context.findRenderObject() as RenderBox?;
            BoxHitTestResult hitTestResult = BoxHitTestResult();
            renderBox?.hitTest(hitTestResult, position: flutterCoordinates);
            if (hitTestResult.path.isNotEmpty) {
              GestureBinding.instance.handlePointerEvent(
                  PointerAddedEvent(pointer: 0, position: flutterCoordinates));
              GestureBinding.instance.handlePointerEvent(
                  PointerDownEvent(pointer: 0, position: flutterCoordinates));
              GestureBinding.instance.handlePointerEvent(
                  PointerUpEvent(pointer: 0, position: flutterCoordinates));
            } else {
            }
          }
        }
      }
    });
  }

  /// 2.进入A面时就调用（只调用一次）
  Future<void> pageA() async {
    _quizChannel.invokeMethod('pageA');
  }
  /// 3.进入B面时就调用（只调用一次）
  Future<void> pageB1() async {
    _quizChannel.invokeMethod('pageB1');
  }
  /// 4.进入B面时就调用（只调用一次）
  Future<void> pageB2() async {
    _quizChannel.invokeMethod('pageB2');
  }
  /// 5.点击项目右上角打开web游戏调用（只调用一次）
  Future<void> clickH5() async {
    _quizChannel.invokeMethod('clickH5');
  }
}