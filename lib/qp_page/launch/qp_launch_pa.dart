import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/launch/qp_launch_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';

class QpLaunchPa extends StatelessWidget{
  QpLaunchCon qpLaunchCon=Get.put(QpLaunchCon());
  
  @override
  Widget build(BuildContext context) => WillPopScope(
    child: Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          QpImg(img: "launch",width: double.infinity,height: double.infinity,),
          Column(
            children: [
              SizedBox(height: 108.h,),
              QpImg(img: "launch2",width: 198.w,height: 154.h,),
              Spacer(),
              _progressWidget(),
              SizedBox(height: 233.h,),
            ],
          ),
        ],
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );
  
  _progressWidget()=>Stack(
    alignment: Alignment.centerLeft,
    children: [
      QpImg(img: "launch3",width: 284.w,height: 20.h,),
      Container(
        margin: EdgeInsets.only(left: 2.w,right: 2.w),
        child: GetBuilder<QpLaunchCon>(
          id: "progress",
          builder: (_)=>ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: qpLaunchCon.animationController.value,
              child: QpImg(img: "launch4",width: 280.w,height: 16.h,fit: BoxFit.fill,),
            ),
          ),
        ),
      )
    ],
  );
}