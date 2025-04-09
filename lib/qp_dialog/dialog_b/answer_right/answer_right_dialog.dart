import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_con.dart';
import 'package:quiz_up/qp_dialog/dialog_b/old_user_double/old_user_double_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_lottie.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/utils.dart';

enum AnswerRightTyp{
  quiz,wheel,
}

class AnswerRightDialog extends StatelessWidget{
  bool init=false;
  late AnswerRightCon answerRightCon;

  double addNum;
  AnswerRightTyp type;
  Function() dismiss;
  AnswerRightDialog({
    required this.addNum,
    required this.type,
    required this.dismiss,
});


  @override
  Widget build(BuildContext context){
    if(!init){
      answerRightCon=Get.put(AnswerRightCon());
      PointUtils.instance.pointEvent(AppPointId.coin_pop,data: {"source_from":type==AnswerRightTyp.quiz?"quiz":"wheel"});
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
        // Positioned(
        //   top: 14.h,
        //   right: 0,
        //   child: InkWell(
        //     onTap: (){
        //       answerRightCon.clickClose(dismiss,);
        //     },
        //     child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
        //   ),
        // ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: QpText(text: "Congratulation!", size: 24.sp, color: "#0054B6",fontWeight: FontWeight.w400,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              QpLottie(name: "tanchuang",width: 250.w,height: 250.w,),
              QpImg(img: "right2",width: 116.w,height: 104.h,),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpText(text: "+\$$addNum", size: 32.sp, color: "#085F75"),
              SizedBox(height: 30.h,),
              InkWell(
                onTap: (){
                  answerRightCon.clickDou(addNum,dismiss,type);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QpImg(img: "icon_video",width: 42.w,height: 42.w,),
                        QpText(text: "Claim \$${(Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble()}", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 14.h,),
              InkWell(
                onTap: (){
                  answerRightCon.clickSingle(addNum,dismiss,type);
                },
                child: QpText(text: "Claim", size: 16.sp, color: "#5FB1C5"),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        )
      ],
    ),
  );
}