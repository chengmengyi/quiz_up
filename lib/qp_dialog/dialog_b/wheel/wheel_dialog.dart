import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/wheel/wheel_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';

class WheelDialog extends StatelessWidget{
  int receivedIndex=-1;
  bool init=false,autoWheel=false,fromOldUser=false;
  late WheelCon wheelCon;
  WheelDialog({required this.autoWheel,this.fromOldUser=false,this.receivedIndex=-1});

  @override
  Widget build(BuildContext context){
    if(!init){
      wheelCon=Get.put(WheelCon());
      wheelCon.autoWheel=autoWheel;
      wheelCon.fromOldUser=fromOldUser;
      PointUtils.instance.pointEvent(AppPointId.wheel_pop,data: {"source_from":fromOldUser?"old":"quiz"});
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.center,
          children: [
            QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
            _wheelWidget(),
          ],
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }

  _wheelWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: (){
              wheelCon.clickClose();
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
          SizedBox(width: 20.w,)
        ],
      ),
      Stack(
        alignment: Alignment.topCenter,
        children: [
          _wheelTopWidget(),
          _wheelCenterWidget(),
          _wheelBottomWidget(),
        ],
      )
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

        ],
      ),
    ],
  );

  _wheelCenterWidget()=>Container(
    margin: EdgeInsets.only(top: 82.h),
    child: Stack(
      alignment: Alignment.center,
      children: [
        GetBuilder<WheelCon>(
          id: "wheel",
          builder: (_)=>Transform.rotate(
            angle: wheelCon.currentWheelAngle*(pi/180),
            child: QpImg(img: "wheel6",height: 370.h,fit: BoxFit.fitHeight,),
          ),
        ),
        InkWell(
          onTap: (){
            wheelCon.startWheel(receivedIndex);
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