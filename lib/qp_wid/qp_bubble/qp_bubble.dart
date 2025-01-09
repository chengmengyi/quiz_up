import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_wid/qp_bubble/qp_bubble_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';

class QpBubbleWidget extends StatelessWidget{
  bool _init=false;
  late QpBubbleCon qpBubbleCon;

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpBubbleCon=Get.put(QpBubbleCon());
      _init=true;
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        QpImg(img: "bubble",width: 74.w,height: 74.w,)
      ],
    );
  }
}