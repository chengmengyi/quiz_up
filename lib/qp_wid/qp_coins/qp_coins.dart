import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'qp_coins_con.dart';

class QpCoins extends StatelessWidget{
  late QpCoinsCon qpCoinsCon;
  bool _init=false;
  String conTag;
  QpCoins({
    required this.conTag,
  });

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpCoinsCon=Get.put(QpCoinsCon(),tag: conTag);
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
          child: GetBuilder<QpCoinsCon>(
            id: "coins",
            tag: conTag,
            builder: (_)=>QpText(
              text: "${qpCoinsCon.userCoins}",
              size: 14.sp,
              color: "#FFFFFF",
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        QpImg(img: "icon_coins",width: 42.w,height: 42.h,),
      ],
    );
  }
}