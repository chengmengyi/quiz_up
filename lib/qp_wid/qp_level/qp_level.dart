import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_level/qp_level_con.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class QpLevel extends StatelessWidget{
  late QpLevelCon qpLevelCon;
  bool _init=false;
  String conTag;
  QpLevel({
    required this.conTag,
  });

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpLevelCon=Get.put(QpLevelCon(),tag: conTag);
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
                image: AssetImage("qp_img/icon_level_bg.webp"),
                fit: BoxFit.fill,
              )
          ),
          child: GetBuilder<QpLevelCon>(
            id: "level",
            tag: conTag,
            builder: (_)=>QpText(
              text: "Lv${qpLevelCon.userLevel+1}",
              size: 14.sp,
              color: "#032B66",
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        QpImg(img: "icon_level",width: 42.w,height: 42.h,),
      ],
    );
  }
}