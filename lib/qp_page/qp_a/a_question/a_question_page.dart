import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_a/a_question/a_question_con.dart';
import 'package:quiz_up/qp_wid/qp_coins/qp_coins.dart';
import 'package:quiz_up/qp_wid/qp_gra_text.dart';
import 'package:quiz_up/qp_wid/qp_heart/qp_heart.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_level/qp_level.dart';
import 'package:quiz_up/qp_wid/qp_lottie.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class AQuestionPage extends StatelessWidget{
  AQuestionCon aQuestionCon=Get.put(AQuestionCon());

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
                SizedBox(height: 30.h,),
                _questionWidget(),
              ],
            ),
          ),
          _rightAnswerFingerWidget(),
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
          aQuestionCon.clickClose();
        },
        child: QpImg(img: "icon_close2",width: 60.w,height: 60.h,),
      ),
      QpCoins(conTag: "a_question"),
      QpHeart(conTag: "a_question"),
      QpLevel(conTag: "a_question"),
    ],
  );

  _questionWidget()=>SizedBox(
    width: double.infinity,
    height: 541.h,
    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 5.h),
          child: Stack(
            children: [
              QpImg(img: "q1",width: double.infinity,height: 536.h,),
              Container(
                margin: EdgeInsets.only(top: 54.h,left: 12.w,right: 12.w),
                child: Stack(
                  children: [
                    QpImg(img: "q3",width: double.infinity,height: 448.h,),
                    Container(
                      margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 24.h),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          QpImg(img: "q4",width: double.infinity,height: 394.h,),
                          Container(
                            margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 20.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _questionProgressWidget(),
                                SizedBox(height: 14.h,),
                                _questionContentWidget(),
                                SizedBox(height: 20.h,),
                                _questionResultWidget(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _questionTypeWidget(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: QpImg(img: "q5",width: double.infinity,fit: BoxFit.fitWidth,),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              aQuestionCon.showRightAnswerFinger();
            },
            child: QpImg(img: "q12",width: 42.w,height: 42.h,),
          ),
        )
      ],
    ),
  );

  _questionProgressWidget()=>GetBuilder<AQuestionCon>(
    id: "progress",
    builder: (_)=>Row(
      children: [
        QpText(
          text: "Level ${aQuestionCon.level+1}",
          size: 19.sp,
          color: "#F7F9FD",
          fontWeight: FontWeight.w800,
          shadows: [
            Shadow(
                color: "#334AC5".toColor(),
                blurRadius: 2.w,
                offset: Offset(0,2.w)
            )
          ],
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: LayoutBuilder(
            builder: (c,bc){
              var width = bc.maxWidth;
              return SizedBox(
                width: width,
                height: 20.h,
                child: Stack(
                  children: [
                    QpImg(img: "q6",width: double.infinity,height: 20.h,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: width*aQuestionCon.getProgress(),
                        height: 14.h,
                        margin: EdgeInsets.only(left: 4.w,right: 4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: ["#7CE9FC".toColor(),"#2B87E5".toColor(),"#5ABFF9".toColor()]
                            )
                        ),
                      ),
                    ),
                    Align(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QpText(text: "Question: ", size: 10.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
                          QpText(text: "${aQuestionCon.questionIndex+1}", size: 10.sp, color: "#4ED5FF",fontWeight: FontWeight.w800,),
                          QpText(text: "/${aQuestionCon.questionLength}", size: 10.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    ),
  );

  _questionContentWidget()=>Container(
    width: double.infinity,
    height: 130.h,
    decoration: BoxDecoration(
      color: "#3366D5".toColor(),
      borderRadius: BorderRadius.circular(12.w),
    ),
    child: Stack(
      children: [
        Positioned(
          top: 6.h,
          left: 8.w,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              QpImg(img: "q7",width: 48.w,height: 20.h,),
              Positioned(
                right: 7.w,
                child: GetBuilder<AQuestionCon>(
                  id: "timer",
                  builder: (_)=>QpText(text: "${aQuestionCon.timeInt}s", size: 10.sp, color: "#FFFFFF",),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(left: 18.w,right: 18.w),
            child: GetBuilder<AQuestionCon>(
              id: "question",
              builder: (_)=>QpText(text: aQuestionCon.currentQuestionBean?.qpQues??"", size: 18.sp, color: "#FFFFFF",textAlign: TextAlign.center,fontWeight: FontWeight.w800,),
            ),
          ),
        )
      ],
    ),
  );

  _questionResultWidget()=>GetBuilder<AQuestionCon>(
    id: "answer",
    builder: (_)=>ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        return Container(
          key: index==0?aQuestionCon.aGlobalKey:aQuestionCon.bGlobalKey,
          margin: EdgeInsets.only(top: 8.h),
          child: InkWell(
            onTap: (){
              aQuestionCon.clickResult(index);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                QpImg(img: aQuestionCon.getAnswerBg(index),width: double.infinity,height: 56.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10.w,),
                    Flexible(
                      child: QpGraText(
                        text: index==0?aQuestionCon.currentQuestionBean?.qpFirst??"":aQuestionCon.currentQuestionBean?.qpSecond??"",
                        size: 19.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w800,
                        colors: ["#FFFFFF".toColor(),"#A9F4FA".toColor()],
                        shadows: [
                          Shadow(
                              color: "#0759A2".toColor(),
                              blurRadius: 2.w,
                              offset: Offset(0,2.w)
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    aQuestionCon.getResultIcon(index).isEmpty?
                    Container():
                    QpImg(img: aQuestionCon.getResultIcon(index),width: 20.w,),
                    SizedBox(width: 10.w,),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ),
  );

  _questionTypeWidget()=>Stack(
    alignment: Alignment.center,
    children: [
      QpImg(img: "q2",width: 250.w,height: 47.h,),
      QpGraText(
        text: aQuestionCon.questionType,
        size: 19.sp,
        fontWeight: FontWeight.w800,
        colors: ["#FFFFFF".toColor(),"#7FDDFF".toColor()],
        shadows: [
          Shadow(
              color: "#334AC5".toColor(),
              blurRadius: 2.w,
              offset: Offset(0,2.w)
          )
        ],
      ),
    ],
  );

  _rightAnswerFingerWidget()=>GetBuilder<AQuestionCon>(
    id: "finger",
    builder: (_)=>Visibility(
      visible: null!=aQuestionCon.rightAnswerOffset,
      child: Container(
        margin: EdgeInsets.only(top: (aQuestionCon.rightAnswerOffset?.dy??0)+20.h,left: (aQuestionCon.rightAnswerOffset?.dx??0)+200.w),
        child: InkWell(
          onTap: (){
            aQuestionCon.clickRightAnswerFinger();
          },
          child: QpLottie(name: "finger",width: 78.w,height: 65.h,),
        ),
      ),
    ),
  );
}