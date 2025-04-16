import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/cash_amount_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_guide/cash_guide_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/utils.dart';

class CashGuideDialog extends StatelessWidget{
  bool init=false;
  late CashGuideCon cashGuideCon;

  CashAmountBean cashAmountBean;
  Function() dismiss;
  CashGuideDialog({
    required this.cashAmountBean,
    required this.dismiss,
  });


  @override
  Widget build(BuildContext context){
    if(!init){
      cashGuideCon=Get.put(CashGuideCon());
      // PointUtils.instance.pointEvent(AppPointId.cash_task_pop,data: {"task_from":cashAmountBean.cashTaskBean?.taskType});
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
        )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QpText(text: "just one step away\nfrom cash withdrawal", size: 16.sp, color: "#000000",textAlign: TextAlign.center,),
        QpText(text: "\$${cashAmountBean.totalMoney??0}", size: 20.sp, color: "#009220"),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.w),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: ["#CCECFF".toColor(),"#E7F6FF".toColor()]
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h,),
              QpImg(img: cashGuideCon.getTaskIcon(cashAmountBean.cashTaskBean),width: 84.w,height: 84.w,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QpText(text: cashGuideCon.getTaskLeftStr(cashAmountBean.cashTaskBean), size: 14.sp, color: "#084B7B"),
                  QpText(text: "${(cashAmountBean.cashTaskBean?.currentPro??0)}/${(cashAmountBean.cashTaskBean?.totalPro??0)}", size: 14.sp, color: "#FB3600")
                ],
              ),
              SizedBox(height: 8.h,),
            ],
          ),
        ),
        SizedBox(height: 25.h,),
        InkWell(
          onTap: (){
            PointUtils.instance.pointEvent(AppPointId.cash_task_pop_c);
            back();
            dismiss.call();

          },
          child: Container(
            width: double.infinity,
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: "#488EE4".toColor(),
            ),
            child: QpText(text: "Go", size: 18.sp, color: "#FFFFFF"),
          ),
        )
      ],
    ),
  );
}