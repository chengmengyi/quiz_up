import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_wid/qp_heart/qp_heart_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class QpHeart extends StatelessWidget{
  late QpHeartCon qpHeartCon;
  bool _init=false;
  String conTag;
  QpHeart({
    required this.conTag,
  });

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpHeartCon=Get.put(QpHeartCon(),tag: conTag);
      _init=true;
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 34.h,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 16.w),
          padding: EdgeInsets.only(left: 32.w,right: 16.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("qp_img/icon_bg.webp"),
                fit: BoxFit.fill,
              )
          ),
          child: GetBuilder<QpHeartCon>(
            id: "heart",
            tag: conTag,
            builder: (_)=>QpText(
              text: "${qpHeartCon.userHeart}/10",
              size: 14.sp,
              color: "#FFFFFF",
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        QpImg(img: "icon_heart",width: 42.w,height: 42.h,),
      ],
    );
  }
}