import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class CommentSuccessDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context)=>WillPopScope(
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

  _contentWidget()=>SizedBox(
    width: double.infinity,
    height: 404.h,
    child: Stack(
      children: [
        QpImg(img: "c1",width: double.infinity,height: double.infinity,),
        Positioned(
          top: 33.h,
          right: 25.w,
          child: InkWell(
            onTap: (){
              QpRouters.back();
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpImg(img: "c5",width: 100.w,height: 100.h,),
              QpText(text: "Thanks for yur feedback", size: 16.sp, color: "#085F75"),
              SizedBox(height: 8.h,),
              InkWell(
                onTap: (){
                  QpRouters.back();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    QpText(text: "OK", size: 20.sp, color: "#FFFFFF")
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