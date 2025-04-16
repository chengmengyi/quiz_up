import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class OpenNotificationDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) => WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 40.w,right: 40.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.w),
            gradient: LinearGradient(colors: ["#E0FCFF".toColor(),"#FFFFFF".toColor()]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.h,),
              QpText(text: "turn on push notifications", size: 18.sp, color: "#000000"),
              SizedBox(height: 10.h,),
              QpImg(img: "no_notification",width: 164.w,height: 132.h,),
              SizedBox(height: 10.h,),
              InkWell(
                onTap: (){
                  QpRouters.back();
                  AppSettings.openAppSettings(type: AppSettingsType.notification);
                },
                child: Container(
                  width: double.infinity,
                  height: 45.h,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 20.w,right: 20.w),
                  decoration: BoxDecoration(
                    color: "#488EE4".toColor(),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: QpText(text: "Go and Open", size: 18.sp, color: "#FFFFFF"),
                ),
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );
}