import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/box/box_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class BoxDialog extends StatelessWidget{
  bool init=false;
  late BoxCon boxCon;

  int index;
  BoxDialog({required this.index});

  @override
  Widget build(BuildContext context){
    if(!init){
      boxCon=Get.put(BoxCon());
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
              back();
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: QpText(text: "Congratulation!", size: 24.sp, color: "#0054B6",fontWeight: FontWeight.w400,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 26.h),
            child: SizedBox(
              width: 250.w,
              height: 250.h,
              child: Stack(
                children: [
                  QpImg(img: "guang",width: 250.w,height: 250.h,),
                  Align(
                    alignment: Alignment.center,
                    child: QpImg(img: "box2",width: 134.w,height: 118.h,),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40.h),
                      child: QpText(text: "+\$60.0", size: 32.sp, color: "#085F75"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  boxCon.clickDou(index);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QpImg(img: "icon_video",width: 42.w,height: 42.w,),
                        QpText(text: "Claim \$${(Decimal.parse("100")*Decimal.fromInt(2)).toDouble()}", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 18.h,),
              InkWell(
                onTap: (){
                  boxCon.clickSingle(index);
                },
                child: QpText(text: "\$20.0", size: 16.sp, color: "#5FB1C5"),
              ),
              SizedBox(height: 18.h,)
            ],
          ),
        )
      ],
    ),
  );
}