import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/cash_rank/cash_rank_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class CashRankDialog extends StatelessWidget{
  bool init=false;
  late CashRankCon cashRankCon;

  int cashNum;
  int cashType;
  CashRankDialog({
    required this.cashNum,
    required this.cashType,
  });


  @override
  Widget build(BuildContext context){
    if(!init){
      cashRankCon=Get.put(CashRankCon());
      cashRankCon.cashNum=cashNum;
      cashRankCon.cashType=cashType;
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
    height: 511.h,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    child: Stack(
      children: [
        QpImg(img: "rank1",width: double.infinity,height: 511.h,),
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
            child: QpText(text: "Withdraw approval", size: 24.sp, color: "#0054B6",fontWeight: FontWeight.w400,),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 64.h,),
              _infoWidget(),
              SizedBox(height: 10.h,),
              _rankWidget(),
              _btnWidget(),
              SizedBox(height: 26.h,),
            ],
          ),
        )
      ],
    ),
  );

  _infoWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      QpImg(img: cashRankCon.cashTypeList[cashType],width: 60.w,height: 60.w,),
      QpText(text: "$cashNum", size: 20.sp, color: "#F8E73F",fontWeight: FontWeight.bold,),
      QpText(text: "Congratulations,you are in the withdrawal approval queue.", size: 14.sp, color: "#137088",fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
    ],
  );

  _rankWidget()=>Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: "288",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#FF3333".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextSpan(
                    text: " in queue,Your Current rank:",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#000000".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextSpan(
                    text: "22",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#FF3333".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                ),
              ]
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 22.w,right: 22.w,top: 10.h,bottom: 10.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.w),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.w),
                        border: Border.all(
                          width: 1.w,
                          color: "#33ACE7".toColor(),
                        )
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 38.h,
                        color: "#C6EEFF".toColor(),
                        child: Row(
                          children: [
                            _rankTitleItemWidget("Rank"),
                            _rankTitleItemWidget("Account"),
                            _rankTitleItemWidget("Amount"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 100,
                          itemBuilder: (context,index){
                            return Container(
                              width: double.infinity,
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: index%2==0?"#E1F6FF".toColor():"#C6EEFF".toColor(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  _rankTitleItemWidget(String title)=>Expanded(
    child: Container(
      height: 38.h,
      alignment: Alignment.center,
      child: QpText(text: title, size: 14.sp, color: "#254A99",fontWeight: FontWeight.bold,),
    ),
  );

  _btnWidget()=>InkWell(
    onTap: (){

    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "btn2",width: 228.w,height: 60.h,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            QpImg(img: "icon_video",width: 42.w,height: 42.w,),
            QpText(text: "Skip Wait", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
          ],
        )
      ],
    ),
  );
}