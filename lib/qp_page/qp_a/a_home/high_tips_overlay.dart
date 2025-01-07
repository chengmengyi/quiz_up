import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/overlay_utils.dart';

class HighTipsOverlay extends StatelessWidget{
  Offset offset;
  HighTipsOverlay({required this.offset});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: (){
        OverlayUtils.instance.hideOver();
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy-30.h,
              right: 0,
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16.w),
                padding: EdgeInsets.only(left: 32.w,right: 16.w),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("qp_img/unlock_tips.webp"),
                      fit: BoxFit.fill,
                    )
                ),
                child: QpText(text: "Unlocked At Level 8", size: 13.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
              ),
            ),
          ],
        ),
      ),
    ),
  );

}