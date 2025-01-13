import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/firebase_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class QpBubbleCon extends GetxController implements EventListener{
  var maxWidth=0.0,maxHeight=0.0,startRight=true,startDown=true,top=0.0,left=0.0,showBubble=true;
  GlobalKey globalKey=GlobalKey();
  Timer? _timer;
  late ReceiveEvent _receiveEvent;
  double addNum=ValueUtils.instance.getBubbleAddNum();

  @override
  void onInit() {
    super.onInit();
    _receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _initTimer();
  }

  clickBubble(){
    if(firstClickBubble.get()){
      firstClickBubble.save(false);
      _addNumResult();
      return;
    }
    AdUtils.instance.showAd(
      closeAd: (){
        _addNumResult();
      }
    );
  }

  _addNumResult()async{
    showBubble=false;
    update(["pos"]);
    BSql.instance.updateUserMoney(addNum);
    await Future.delayed(Duration(seconds: FirebaseUtils.instance.float_dis));
    showBubble=true;
    update(["pos"]);
  }

  _initTimer(){
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    maxWidth=size.width-74.w;
    maxHeight=size.height-74.w;
    _timer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(startRight){
        left++;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left>=maxWidth){
          startRight=false;
        }
      }else{
        left--;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left<=0){
          startRight=true;
        }
      }
      update(["pos"]);
    });
  }


  @override
  receivedEvent(SendEvent event) {
    if(event.code==EventCode.updateUserMoney){
      addNum=ValueUtils.instance.getBubbleAddNum();
      update(["pos"]);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer=null;
    _receiveEvent.cancel();
    super.onClose();
  }
}