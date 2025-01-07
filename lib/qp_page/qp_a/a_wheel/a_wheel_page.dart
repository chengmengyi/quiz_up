import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_a/a_wheel/a_wheel_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class AWheelPage extends StatelessWidget{
  late AWheelCon aWheelCon;
  bool init=false;

  @override
  Widget build(BuildContext context) {
    if(!init){
      aWheelCon = Get.put(AWheelCon());
      init=true;
    }
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
            SafeArea(
              top: true,
              bottom: true,
              child: Column(
                children: [
                  _titleWidget(),
                  Expanded(
                    child: Center(
                      child: _wheelWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }

  _titleWidget()=>Row(
    children: [
      SizedBox(width: 16.w,),
      InkWell(
        onTap: (){
          aWheelCon.clickClose();
        },
        child: QpImg(img: "icon_close1",width: 30.w,height: 30.h,),
      ),
      SizedBox(width: 10.w,),
      QpText(text: "Spin The Classic", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
    ],
  );

  _wheelWidget()=>Stack(
    alignment: Alignment.topCenter,
    children: [
      _wheelTopWidget(),
      _wheelCenterWidget(),
      _wheelBottomWidget(),
    ],
  );
  
  _wheelTopWidget()=>Stack(
    alignment: Alignment.topCenter,
    children: [
      Container(
        margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 22.h),
        child: QpImg(img: "wheel2",width: double.infinity,height: 135.h,),
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          QpImg(img: "wheel1",width: 270.w,height: 54.h,),
          GetBuilder<AWheelCon>(
            id: "type",
            builder: (_)=>QpText(text: aWheelCon.getRandomTypeByAngle(), size: 28.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
          ),
        ],
      ),
    ],
  );

  _wheelCenterWidget()=>Container(
    margin: EdgeInsets.only(top: 82.h),
    child: Stack(
      alignment: Alignment.center,
      children: [
        GetBuilder<AWheelCon>(
          id: "wheel",
          builder: (_)=>Transform.rotate(
            angle: aWheelCon.currentWheelAngle*(pi/180),
            child: QpImg(img: "wheel4",height: 370.h,fit: BoxFit.fitHeight,),
          ),
        ),
        InkWell(
          onTap: (){
            aWheelCon.start();
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              QpImg(img: "wheel5",width: 93.w,fit: BoxFit.fitWidth,),
              Positioned(
                bottom: 30.h,
                child: QpText(text: "Spin", size: 24.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
              )
            ],
          ),
        ),
      ],
    ),
  );
  
  _wheelBottomWidget()=>Container(
    margin: EdgeInsets.only(top: 370.h,left: 16.w,right: 16.w),
    child: QpImg(img: "wheel3",width: double.infinity,fit: BoxFit.fitWidth,),
  );
}