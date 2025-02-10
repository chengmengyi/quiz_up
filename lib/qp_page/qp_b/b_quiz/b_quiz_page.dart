import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/progress_bean.dart';
import 'package:quiz_up/qp_page/qp_a/a_question/a_question_con.dart';
import 'package:quiz_up/qp_page/qp_b/b_quiz/b_quiz_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/qp_wid/qp_bubble/qp_bubble.dart';
import 'package:quiz_up/qp_wid/qp_coins/qp_coins.dart';
import 'package:quiz_up/qp_wid/qp_gra_text.dart';
import 'package:quiz_up/qp_wid/qp_heart/qp_heart.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_level/qp_level.dart';
import 'package:quiz_up/qp_wid/qp_lottie.dart';
import 'package:quiz_up/qp_wid/qp_money/qp_money_widget.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/h5_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';

class BQuizPage extends StatelessWidget{
  BQuizCon bQuizCon=Get.put(BQuizCon());

  @override
  Widget build(BuildContext context){
    bQuizCon.context=context;
    return Scaffold(
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
                  SizedBox(height: 2.h,),
                  _progressWidget(),
                  SizedBox(height: 2.h,),
                  _questionWidget(),
                ],
              ),
            ),
            _rightAnswerFingerWidget(),
            _bubbleWidget(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _bottomCashWidget(),
            ),
            _moneyAnimatorWidget(),
          ],
        ),
        onWillPop: ()async{
          return false;
        },
      ),
    );
  }

  _topWidget()=>Row(
    children: [
      SizedBox(width: 10.w,),
      QpMoneyWidget(),
      _earnWidget(),
      InkWell(
        onTap: (){
          toNamed(routersName: QpRouName.setting);
        },
        child: QpImg(img: "icon_set",width: 47.w,height: 47.h,),
      ),
      SizedBox(width: 10.w,),
    ],
  );

  _earnWidget()=>Expanded(
    child: GetBuilder<BQuizCon>(
      id: "earn",
      builder: (_)=>Visibility(
        visible: (BSql.instance.bUserInfo?.money??0.0)<2000,
        child: Container(
          height: 62.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 18.w,right: 10.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("qp_img/earn_bg.webp"),
                fit: BoxFit.fill,
              )
          ),
          // child: QpText(text: "Earn \$${ValueUtils.instance.getEarnNum()} moreto\nwithdraw \$${ValueUtils.instance.getMaxCashNum()}", size: 10.sp, color: "#351900"),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Earn ",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: "#351900".toColor(),
                              fontFamily: "qp"
                          )
                      ),
                      TextSpan(
                          text: "\$${ValueUtils.instance.getEarnNum()}",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: "#FF003D".toColor(),
                              fontFamily: "qp"
                          )
                      ),
                      TextSpan(
                          text: "moreto",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: "#351900".toColor(),
                              fontFamily: "qp"
                          )
                      ),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "withdraw ",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: "#351900".toColor(),
                              fontFamily: "qp"
                          )
                      ),
                      TextSpan(
                          text: "\$${ValueUtils.instance.getMaxCashNum()}",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: "#FF003D".toColor(),
                              fontFamily: "qp"
                          )
                      ),
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );

  _progressWidget()=>Container(
    width: double.infinity,
    height: 60.w,
    margin: EdgeInsets.only(left: 16.w,right: 16.w),
    child: GetBuilder<BQuizCon>(
      id: "progress",
      builder: (_)=>SizedBox(
        width: double.infinity,
        height: 60.w,
        key: bQuizCon.progressGlobalKey,
        child: ListView.builder(
          itemCount: ProgressUtils.instance.progressList.length,
          scrollDirection: Axis.horizontal,
          controller: bQuizCon.scrollController,
          itemBuilder: (context,index){
            var isEnd = index==ProgressUtils.instance.progressList.length-1;
            var bean = ProgressUtils.instance.progressList[index];
            var canReceive = !bean.received&&(BSql.instance.bUserInfo?.answerNum??0)-1>=index;
            var showLeftPro = ProgressUtils.instance.showLeftPro(index);
            var showRightPro = ProgressUtils.instance.showRightPro(index);
            switch(bean.progressType){
              case ProgressType.empty: return _proEmptyWidget(index,index==0,isEnd);
              case ProgressType.box: return _proBoxWidget(index,bean,canReceive,showLeftPro,showRightPro);
              case ProgressType.wheel: return _proWheelWidget(index,bean,canReceive,showLeftPro,showRightPro);
            }
          },
        ),
      ),
    ),
  );

  _proEmptyWidget(index,bool isStart,bool isEnd)=>Container(
    width: 10.w,
    height: 60.h,
    alignment: Alignment.center,
    child: Container(
      width: 10.w,
      height: 20.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: isStart?2.w:0,right: isEnd?2.w:0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isStart?Radius.circular(14.w):Radius.zero,
          bottomLeft: isStart?Radius.circular(14.w):Radius.zero,
          topRight: isEnd?Radius.circular(14.w):Radius.zero,
          bottomRight: isEnd?Radius.circular(14.w):Radius.zero,
        ),
        color: "#000000".toColor().withOpacity(0.5),
      ),
      child:  Container(
        width: double.infinity,
        height: 16.h,
        decoration: ProgressUtils.instance.emptyProHasValue(index)?
        BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isStart?Radius.circular(10.w):Radius.zero,
            bottomLeft: isStart?Radius.circular(10.w):Radius.zero,
            topRight: isEnd?Radius.circular(10.w):Radius.zero,
            bottomRight: isEnd?Radius.circular(10.w):Radius.zero,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ["#F2B839".toColor(),"#DF6224".toColor()],
          ),
        ):
        null,
      ),
    ),
  );
  
  _proBoxWidget(index,ProgressBean bean,bool canReceive,showLeftPro,showRightPro)=>InkWell(
    onTap: (){
      ProgressUtils.instance.clickBoxOrWheel(index,canReceive);
    },
    child: Container(
      width: 60.w,
      height: 60.w,
      key: index==1?bQuizCon.box2GlobalKey:null,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: _proValueWidget(showLeftPro),
              ),
              Expanded(
                child: _proValueWidget(showRightPro),
              ),
            ],
          ),
          canReceive?QpImg(img: "pro3",width: 60.w,height: 60.w,):QpImg(img: bean.received?"pro1":"pro2",width: 42.w,height: 42.w,),
          Visibility(
            visible: ProgressUtils.instance.showFinger(index),
            child: SizedBox(
              width: 60.w,
              height: 60.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ShakeAnimationWidget(
                      shakeAnimationType: ShakeAnimationType.RoateShake,
                      isForward: true,
                      shakeCount: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 2.w,right: 2.w),
                        decoration: BoxDecoration(
                          color: "#000000".toColor().withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: QpText(text: "Max\$${ValueUtils.instance.getBoxMaxAddNum()}", size: 9.sp, color: "#FFFFFF"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: QpLottie(name: "finger",width: 46.w,height: 46.w,),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: QpGraText(
              text: "${index+1}",
              size: 14.sp,
              fontWeight: FontWeight.bold,
              colors: bean.received?["#F1F1F1".toColor(),"#B6B6B6".toColor()]:["#FDFF5F".toColor(),"#F76B00".toColor()],
            ),
          )
        ],
      ),
    ),
  );

  _proWheelWidget(index,ProgressBean bean,bool canReceive,showLeftPro,showRightPro)=>InkWell(
    onTap: (){
      ProgressUtils.instance.clickBoxOrWheel(index,canReceive);
    },
    child: Container(
      width: 60.w,
      height: 60.w,
      key: index==9?bQuizCon.wheel10GlobalKey:null,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: _proValueWidget(showLeftPro),
              ),
              Expanded(
                child: _proValueWidget(showRightPro),
              ),
            ],
          ),
          canReceive?QpImg(img: "pro6",width: 60.w,height: 60.w,):QpImg(img: bean.received?"pro4":"pro5",width: 42.w,height: 42.w,),
          Visibility(
            visible: ProgressUtils.instance.showFinger(index),
            child: SizedBox(
              width: 60.w,
              height: 60.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ShakeAnimationWidget(
                      shakeAnimationType: ShakeAnimationType.RoateShake,
                      isForward: true,
                      shakeCount: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 2.w,right: 2.w),
                        decoration: BoxDecoration(
                          color: "#000000".toColor().withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: QpText(text: "Max\$${ValueUtils.instance.getBoxMaxAddNum()}", size: 9.sp, color: "#FFFFFF"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: QpLottie(name: "finger",width: 46.w,height: 46.w,),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: QpGraText(
              text: "${index+1}",
              size: 14.sp,
              fontWeight: FontWeight.bold,
              colors: bean.received?["#F1F1F1".toColor(),"#B6B6B6".toColor()]:["#FDFF5F".toColor(),"#F76B00".toColor()],
            ),
          )
        ],
      ),
    ),
  );

  _proValueWidget(showPro)=>Container(
    width: double.infinity,
    height: 20.h,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: "#000000".toColor().withOpacity(0.5),
    ),
    child: showPro?
    Container(
      width: double.infinity,
      height: 16.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ["#F2B839".toColor(),"#DF6224".toColor()],
        ),
      ),
    ):
    Container(),
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
              bQuizCon.showRightAnswerFinger();
            },
            child: QpImg(img: "q12",width: 42.w,height: 42.h,),
          ),
        ),
        Positioned(
          top: 50.h,
          left: 8.w,
          child: InkWell(
            onTap: (){
              H5Utils.instance.clickH5();
            },
            child: QpImg(img: "home_h5",width: 62.w,height: 62.w,),
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
                child: GetBuilder<BQuizCon>(
                  id: "timer",
                  builder: (_)=>QpText(text: "${bQuizCon.timeInt}s", size: 10.sp, color: "#FFFFFF",),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(left: 18.w,right: 18.w),
            child: GetBuilder<BQuizCon>(
              id: "question",
              builder: (_)=>QpText(text: bQuizCon.currentQuestionBean?.qpQues??"", size: 18.sp, color: "#FFFFFF",textAlign: TextAlign.center,fontWeight: FontWeight.w800,),
            ),
          ),
        )
      ],
    ),
  );

  _questionResultWidget()=>GetBuilder<BQuizCon>(
    id: "answer",
    builder: (_)=>ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        return Container(
          key: index==0?bQuizCon.aGlobalKey:bQuizCon.bGlobalKey,
          margin: EdgeInsets.only(top: 8.h),
          child: InkWell(
            onTap: (){
              bQuizCon.clickResult(index);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                QpImg(img: bQuizCon.getAnswerBg(index),width: double.infinity,height: 56.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10.w,),
                    GetBuilder<BQuizCon>(
                      id: "finger",
                      builder: (_)=>Visibility(
                        visible: bQuizCon.showAnswerMoneyIcon(index),
                        child: QpImg(img: "icon_money",width: 24.w,height: 24.h,),
                      ),
                    ),
                    SizedBox(width: 2.w,),
                    Flexible(
                      child: QpGraText(
                        text: index==0?bQuizCon.currentQuestionBean?.qpFirst??"":bQuizCon.currentQuestionBean?.qpSecond??"",
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
                    bQuizCon.getResultIcon(index).isEmpty?
                    Container():
                    QpImg(img: bQuizCon.getResultIcon(index),width: 20.w,),
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

  _questionTypeWidget()=>InkWell(
    onTap: (){
      bQuizCon.test();
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "q2",width: 250.w,height: 47.h,),
        GetBuilder<BQuizCon>(
          id: "level",
          builder: (_)=>QpText(
            text: "Level ${bQuizCon.level+1}",
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
        )
      ],
    ),
  );

  _rightAnswerFingerWidget()=>GetBuilder<BQuizCon>(
    id: "finger",
    builder: (_)=>Visibility(
      visible: null!=bQuizCon.rightAnswerOffset,
      child: Container(
        margin: EdgeInsets.only(top: (bQuizCon.rightAnswerOffset?.dy??0)+20.h,left: (bQuizCon.rightAnswerOffset?.dx??0)+200.w),
        child: InkWell(
          onTap: (){
            bQuizCon.clickRightAnswerFinger();
          },
          child: QpLottie(name: "finger",width: 78.w,height: 65.h,),
        ),
      ),
    ),
  );

  _bubbleWidget()=>GetBuilder<BQuizCon>(
    id: "bubble",
    builder: (_)=>Visibility(
      visible: bQuizCon.showBubble,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: bQuizCon.top,
              left: bQuizCon.left,
              child: InkWell(
                onTap: (){
                  bQuizCon.clickBubble();
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    QpImg(img: "bubble",width: 74.w,height: 74.w,),
                    QpGraText(
                      text: "+\$${bQuizCon.bubbleAddNum}",
                      size: 17.sp,
                      fontWeight: FontWeight.w800,
                      colors: ["#FDFF5F".toColor(),"#F76B00".toColor()],
                      shadows: [
                        Shadow(
                            color: "#794801".toColor(),
                            blurRadius: 2.w,
                            offset: Offset(0,2.w)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );

  _bottomCashWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(left: 50.w),
        child: ShakeAnimationWidget(
          shakeAnimationType: ShakeAnimationType.TopBottomShake,
          isForward: true,
          shakeCount: 0,
          child: QpImg(img: "q13",width: 96.w,height: 43.h,),
        ),
      ),
      InkWell(
        onTap: (){
          toNamed(routersName: QpRouName.bCash);
        },
        child: QpImg(img: "icon_cash",width: 76.w,height: 76.h,),
      ),
      SizedBox(height: 16.h,),
    ],
  );

  _moneyAnimatorWidget()=>GetBuilder<BQuizCon>(
    id: "money_lottie",
    builder: (_)=>Visibility(
      visible: bQuizCon.showMoneyLottie,
      child: QpLottie(
        name: "money",
        repeat: false,
        controller: bQuizCon.moneyLottieController,
      ),
    ),
  );
}