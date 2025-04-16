import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/no_money/no_money_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/utils.dart';

class NoMoneyDialog extends StatelessWidget{
  bool init=false;
  late NoMoneyCon noMoneyCon;
  

  @override
  Widget build(BuildContext context){
    if(!init){
      noMoneyCon=Get.put(NoMoneyCon());
      PointUtils.instance.pointEvent(AppPointId.cash_not_pop);
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            margin: EdgeInsets.only(left: 40.w,right: 40.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.w),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ["#E0FCFF".toColor(),"#FFFFFF".toColor()],
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QpText(text: "insufficient balance", size: 20.sp, color: "#000000"),
                SizedBox(height: 20.h,),
                QpText(text: "Your account balance is insufficient and withdrawal is temporarily unavailable.Go and earn cash！", size: 14.sp, color: "#084B7B",textAlign: TextAlign.center,),
                SizedBox(height: 20.h,),
                InkWell(
                  onTap: (){
                    PointUtils.instance.pointEvent(AppPointId.cash_not_pop_c);
                    QpRouters.back();
                    QpRouters.back();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: "#488EE4".toColor(),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: QpText(text: "Earn More Cash", size: 18.sp, color: "#FFFFFF"),
                  ),
                )
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
}