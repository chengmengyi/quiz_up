import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_b/b_cash/b_cash_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';

class BCashPage extends StatelessWidget{
  BCashCon bCashCon=Get.put(BCashCon());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: WillPopScope(
      child: Stack(
        children: [
          QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
          SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                _topWidget(),
              ],
            ),
          ),
        ],
      ),
      onWillPop: ()async{
        return false;
      },
    ),
  );

  _topWidget()=>Row(
    children: [
      InkWell(
        onTap: (){
          back();
        },
        child: QpImg(img: "icon_close2",width: 60.w,height: 60.h,),
      ),
    ],
  );
}