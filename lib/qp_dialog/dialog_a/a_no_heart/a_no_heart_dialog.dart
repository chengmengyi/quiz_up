import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_no_heart/a_no_heart_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class ANoHeartDialog extends StatelessWidget{
  late ANoHeartCon noHeartCon;
  bool init=false;
  @override
  Widget build(BuildContext context) {
    if(!init){
      noHeartCon=Get.put(ANoHeartCon());
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: _contentWidget(),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }

  _contentWidget()=>SizedBox(
    width: double.infinity,
    height: 375.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "fail1",width: double.infinity,height: 375.h,),
        Positioned(
          top: 28.h,
          right: 20.w,
          child: InkWell(
            onTap: (){
              // answerFailCon.clickContinue(dismiss);
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QpText(text: "No More Chance", size: 24.sp, color: "#FD8700",fontWeight: FontWeight.w400,),
            SizedBox(height: 10.h,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                QpImg(img: "no_heart1",width: 90.w,height: 90.h,),
                QpText(
                  text: "x3",
                  size: 20.sp,
                  color: "#FFFFFF",
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                        color: "#013A49".toColor(),
                        blurRadius: 2.w,
                        offset: Offset(0,2.w)
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
              margin: EdgeInsets.only(left: 58.w,right: 58.w),
              child: QpText(text: "Sorry,The Number Of Answers Today Has Been Exhausted.", size: 14.sp, color: "#085F75",fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10.h,),
            InkWell(
              onTap: (){
                noHeartCon.clickSpend();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QpImg(img: "btn2",width: 228.w,height: 60.h,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QpText(text: "Spend 50", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
                      QpImg(img: "icon_coins",width: 38.w,height: 38.w,)
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}