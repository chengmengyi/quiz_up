import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_lottie.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';

class BoxGuideOverlay extends StatelessWidget{
  Offset offset;
  Function() dismiss;
  BoxGuideOverlay({required this.offset,required this.dismiss});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.6),
        child:InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            GuideUtils.instance.hideGuideOver();
            dismiss.call();
          },
          child: Stack(
            children: [
              Positioned(
                top: offset.dy,
                left: offset.dx,
                child: QpImg(img: "pro3",width: 60.w,height: 60.w,),
              ),
              Positioned(
                top: offset.dy,
                left: offset.dx+60.w,
                child: Container(
                  padding: EdgeInsets.only(left: 16.w,right: 10.w,top: 12.h,bottom: 12.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("qp_img/box_overlay.webp"),
                        fit: BoxFit.fill,
                      )
                  ),
                  child: QpText(text: "pass 3 questions to get a\ntreasure chest reward", size: 14.sp, color: "#351900"),
                ),
              ),
              Positioned(
                top: offset.dy+10.w,
                left: offset.dx+20.w,
                child: QpLottie(name: "finger",width: 78.w,height: 65.h,),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}