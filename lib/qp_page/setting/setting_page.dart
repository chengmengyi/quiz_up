import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/setting/setting_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class SettingPage extends StatelessWidget{
  SettingCon settingCon=Get.put(SettingCon());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      alignment: Alignment.topCenter,
      children: [
        QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
        SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _titleWidget(),
              SizedBox(height: 20.h,),
              _itemWidget("privacy","Privacy Policy"),
              SizedBox(height: 20.h,),
              _itemWidget("term","Term Of User"),
              SizedBox(height: 20.h,),
              _itemWidget("contact","Contact Us"),
            ],
          ),
        ),
      ],
    ),
  );

  _itemWidget(icon,text,)=>InkWell(
    onTap: (){
      settingCon.clickItem(text);
    },
    child: Container(
      margin: EdgeInsets.only(left: 16.w,right: 16.w),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          QpImg(img: "set",width: double.infinity,height: 58.h,),
          Row(
            children: [
              SizedBox(width: 20.w,),
              QpImg(img: icon,width: 24.w,height: 24.w,),
              SizedBox(width: 20.w,),
              QpText(text: text, size: 16.sp, color: "#1F288C",fontWeight: FontWeight.w400,),
              Spacer(),
              QpImg(img: "right",width: 9.w,height: 16.h,),
              SizedBox(width: 20.w,),
            ],
          )
        ],
      ),
    ),
  );

  _titleWidget()=>Row(
    children: [
      SizedBox(width: 16.w,),
      InkWell(
        onTap: (){
          QpRouters.back();
        },
        child: QpImg(img: "icon_close1",width: 30.w,height: 30.h,),
      ),
      SizedBox(width: 10.w,),
      QpText(text: "Setting", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
    ],
  );
}