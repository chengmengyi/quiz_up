import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_success/cash_success_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class CashSuccessDialog extends StatelessWidget{
  bool init=false;
  late CashSuccessCon cashSuccessCon;

  int cashNum;
  int cashType;
  CashSuccessDialog({
    required this.cashNum,
    required this.cashType,
  });

  @override
  Widget build(BuildContext context) {
    if(!init){
      cashSuccessCon=Get.put(CashSuccessCon());
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
  _contentWidget()=>Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.w),
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.w),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ["#E0FCFF".toColor(),"#FFFFFF".toColor()],
        ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QpText(text: "Withdrawal Successful", size: 16.sp, color: "#000000",textAlign: TextAlign.center,fontWeight: FontWeight.bold,),
        SizedBox(height: 10.h,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.w),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: ["#CCECFF".toColor(),"#E7F6FF".toColor()],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpImg(img: cashSuccessCon.cashTypeList[cashType],width: 60.w,height: 60.w,),
              QpText(text: "$cashNum", size: 20.sp, color: "#F8E73F",fontWeight: FontWeight.bold,),
            ],
          ),
        ),
        SizedBox(height: 10.h,),
        QpText(text: "Your withdrawal amount has been issued and will arrive in 3-5 working days. please check your account.", size: 14.sp, color: "#084B7B",),
        SizedBox(height: 10.h,),
        InkWell(
          onTap: (){
            cashSuccessCon.clickBtn(cashType, cashNum);
          },
          child: Container(
            width: double.infinity,
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: "#488EE4".toColor(),
              borderRadius: BorderRadius.circular(20.w)
            ),
            child: QpText(text: "I Know", size: 18.sp, color: "#FFFFFF"),
          ),
        )
      ],
    ),
  );
}