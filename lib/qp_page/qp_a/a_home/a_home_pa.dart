import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/qp_wid/qp_coins/qp_coins.dart';
import 'package:quiz_up/qp_wid/qp_heart/qp_heart.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_level/qp_level.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'a_home_con.dart';

class AHomePa extends StatelessWidget{
  AHomeCon qpHomeCon=Get.put(AHomeCon());
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      alignment: Alignment.topCenter,
      children: [
        QpImg(img: "launch",width: double.infinity,height: double.infinity,),
        SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              _topWidget(),
              SizedBox(height: 20.h,),
              _logoWidget(),
              listWidget(context),
              _btnWidget(context),
              SizedBox(height: 50.h,),
            ],
          ),
        ),
      ],
    ),
  );

  _topWidget()=>Row(
    children: [
      QpCoins(conTag: "a_home"),
      QpHeart(conTag: "a_home"),
      QpLevel(conTag: "a_home"),
      Spacer(),
      InkWell(
        onTap: (){
          toNamed(routersName: QpRouName.setting);
        },
        child: QpImg(img: "icon_set",width: 48.w,height: 48.h,),
      ),
      SizedBox(width: 16.w,),
    ],
  );

  _logoWidget()=>QpImg(img: "launch2",width: 198.w,height: 152.h,);

  listWidget(BuildContext context)=>Expanded(
    child: GetBuilder<AHomeCon>(
      id: "list",
      builder: (_)=>ListView.builder(
        itemCount: qpHomeCon.homeList.length,
        itemBuilder: (context,index){
          var bean = qpHomeCon.homeList[index];
          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QpImg(img: bean.star,height: 34.h,fit: BoxFit.fitHeight,),
                InkWell(
                  onTap: (){
                    qpHomeCon.clickPlay(index,context);
                  },
                  child: Stack(
                    key: index==2?qpHomeCon.highGlobalKey:null,
                    alignment: Alignment.center,
                    children: [
                      QpImg(img: bean.open?"btn_sel":"btn_uns",width: 210.w,height: 66.h,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QpText(
                            text: bean.btn,
                            size: 22.sp,
                            color: bean.open?"#875D02":"#616161",
                          ),
                          Visibility(
                            visible: !bean.open,
                            child: QpImg(img: "lock",width: 38.w,height: 38.h,),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ),
  );

  _btnWidget(BuildContext context)=>InkWell(
    onTap: (){
      qpHomeCon.clickPlay(0,context);
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "btn1",width: 282.w,height: 66.h,),
        QpText(text: "Play Now", size: 22.sp, color: "#FEFFFD",fontWeight: FontWeight.w500,)
      ],
    ),
  );
}