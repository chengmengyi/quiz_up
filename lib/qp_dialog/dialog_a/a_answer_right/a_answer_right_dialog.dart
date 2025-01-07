import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_a/a_answer_right/a_answer_right_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class AAnswerRightDialog extends StatelessWidget{
  Function() dismiss;
  AAnswerRightDialog({
    required this.dismiss,
});

  bool init=false;

  late AAnswerRightCon answerRightCon;

  @override
  Widget build(BuildContext context){
    if(!init){
      answerRightCon=Get.put(AAnswerRightCon());
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
              answerRightCon.clickReward(dismiss);
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
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpImg(img: "icon_coins1",width: 146.w,height: 105.h,),
              SizedBox(height: 2.h,),
              QpText(text: "+${answerRightCon.addReward}", size: 32.sp, color: "#085F75",fontWeight: FontWeight.bold,),
              SizedBox(height: 8.h,),
              InkWell(
                onTap: (){
                  answerRightCon.clickReward(dismiss);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    QpText(text: "Get Reward", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
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