import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_money/qp_money_con.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class QpMoneyWidget extends StatelessWidget{
  bool _init=false;
  late QpMoneyCon qpMoneyCon;

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpMoneyCon=Get.put(QpMoneyCon());
      _init=true;
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 34.h,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 16.w),
          padding: EdgeInsets.only(left: 32.w,right: 4.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("qp_img/icon_bg.webp"),
                fit: BoxFit.fill,
              )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<QpMoneyCon>(
                id: "money",
                builder: (_)=>QpText(
                  text: "\$${BSql.instance.bUserInfo?.money}",
                  size: 14.sp,
                  color: "#FFFFFF",
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 10.w,),
              InkWell(
                onTap: (){
                  toNamed(routersName: QpRouName.bCash);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "cash_btn_bg",width: 68.w,height: 26.h,),
                    QpText(
                      text: "Withdraw",
                      size: 12.sp,
                      color: "#032B66",
                      fontWeight: FontWeight.w800,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        QpImg(img: "icon_money",width: 42.w,height: 42.h,),
      ],
    );
  }

}