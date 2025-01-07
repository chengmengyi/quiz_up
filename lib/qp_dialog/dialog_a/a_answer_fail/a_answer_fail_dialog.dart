import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_fail/a_answer_fail_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class AAnswerFailDialog extends StatelessWidget{
  Function(bool again) dismiss;
  AAnswerFailDialog({
    required this.dismiss,
  });

  bool init=false;
  late AAnswerFailCon answerFailCon;

  @override
  Widget build(BuildContext context) {
    if(!init){
      answerFailCon=Get.put(AAnswerFailCon());
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

  _contentWidget()=>SizedBox(
    width: double.infinity,
    height: 375.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "fail1",width: double.infinity,height: 375.h,),
        Positioned(
          top: 28.h,
          right: 20.w,
          child: InkWell(
            onTap: (){
              answerFailCon.clickContinue(dismiss);
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QpText(text: "Sorry,Wrong Answer", size: 24.sp, color: "#FD8700",fontWeight: FontWeight.w400,),
            SizedBox(height: 16.h,),
            QpImg(img: "fail2",width: 90.w,height: 90.h,),
            SizedBox(height: 14.h,),
            InkWell(
              onTap: (){
                answerFailCon.clickAgain(dismiss);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QpImg(img: "btn2",width: 228.w,height: 60.h,),
                  QpText(text: "Answer Again", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
                ],
              ),
            ),
            SizedBox(height: 14.h,),
            InkWell(
              onTap: (){
                answerFailCon.clickContinue(dismiss);
              },
              child: QpText(text: "Continue", size: 16.sp, color: "#5FA0C5",fontWeight: FontWeight.bold,),
            )
          ],
        )
      ],
    ),
  );
}