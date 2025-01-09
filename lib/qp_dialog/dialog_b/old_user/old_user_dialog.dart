import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/old_user/old_user_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class OldUserDialog extends StatelessWidget{
  bool init=false;
  late OldUserCon oldUserCon;

  @override
  Widget build(BuildContext context){
    if(!init){
      oldUserCon=Get.put(OldUserCon());
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
    height: 394.h,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    child: Stack(
      children: [
        QpImg(img: "right1",width: double.infinity,height: 394.h,),
        Positioned(
          top: 14.h,
          right: 0,
          child: InkWell(
            onTap: (){
              oldUserCon.clickClose();
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: QpText(text: "Daily bouns", size: 24.sp, color: "#0054B6",fontWeight: FontWeight.w400,),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 22.w,right: 22.w),
                decoration: BoxDecoration(
                  color: "#C6DDDD".toColor(),
                  borderRadius: BorderRadius.circular(18.w),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QpText(text: "Spin the wheel daily for prize", size: 16.sp, color: "#137088"),
                    QpImg(img: "icon_wheel",width: 104.w,height: 104.h,),
                    SizedBox(height: 10.h,),
                  ],
                ),
              ),
              SizedBox(height: 30.h,),
              InkWell(
                onTap: (){
                  oldUserCon.clickSpin();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    QpText(text: "Spin", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}