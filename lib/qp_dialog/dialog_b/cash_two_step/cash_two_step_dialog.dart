import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_two_step/cash_two_step_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class CashTwoStepDialog extends StatelessWidget{
  bool init=false;
  late CashTwoStepCon cashTwoStepCon;

  int cashNum;
  int cashType;
  CashTwoStepDialog({
    required this.cashNum,
    required this.cashType,
  });


  @override
  Widget build(BuildContext context){
    if(!init){
      cashTwoStepCon=Get.put(CashTwoStepCon());
      cashTwoStepCon.cashNum=cashNum;
      cashTwoStepCon.cashType=cashType;
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child:  _contentWidget(),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }
  _contentWidget()=>Container(
    width: double.infinity,
    height: 377.h,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    child: Stack(
      children: [
        QpImg(img: "dialog_bg",width: double.infinity,height: 377.h,),
        Positioned(
          top: 14.h,
          right: 0,
          child: InkWell(
            onTap: (){
              back();
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: QpText(text: "Daily Bouns", size: 24.sp, color: "#0054B6",fontWeight: FontWeight.w400,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              _infoWidget(),
              SizedBox(height: 16.h,),
              _progressWidget(),
              SizedBox(height: 16.h,),
              _cashBtnWidget(),
            ],
          ),
        )
      ],
    ),
  );

  _infoWidget()=>Container(
    width: double.infinity,
    padding: EdgeInsets.only(left: 14.w,right: 14.w,top: 10.h,bottom: 10.h),
    margin: EdgeInsets.only(left: 22.w,right: 22.w,top: 64.h),
    decoration: BoxDecoration(
      color: "#C6DDDD".toColor(),
      borderRadius: BorderRadius.circular(18.w),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QpImg(img: cashTwoStepCon.cashTypeList[cashType],width: 60.w,height: 60.w,),
        QpText(text: "$cashNum", size: 20.sp, color: "#F8E73F",fontWeight: FontWeight.bold,),
        QpText(text: "Only one step away from successful withdrawal", size: 14.sp, color: "#137088",fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ],
    ),
  );

  _progressWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      QpText(text: "Scratch 15 Cards", size: 14.sp, color: "#FF1A00",fontWeight: FontWeight.bold,),
      SizedBox(height: 10.h,),
      GetBuilder<CashTwoStepCon>(
        id: "progress",
        builder: (_)=>Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 256.w,
              height: 18.h,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 2.w,right: 2.w),
              decoration: BoxDecoration(
                color: "#778585".toColor(),
                borderRadius: BorderRadius.circular(14.w),
              ),
              child: Container(
                width: cashTwoStepCon.getPro()*252.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: "#F8AB30".toColor(),
                  borderRadius: BorderRadius.circular(14.w),
                ),
              ),
            ),
            QpText(text: cashTwoStepCon.getProStr(), size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
          ],
        ),
      ),
    ],
  );

  _cashBtnWidget()=> InkWell(
    onTap: (){
      cashTwoStepCon.clickBtn();
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "btn2",width: 228.w,height: 60.h,),
        QpText(text: "Cash Out", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
      ],
    ),
  );
}