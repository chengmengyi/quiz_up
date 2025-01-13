import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/input_account/input_account_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class InputAccountDialog extends StatelessWidget{
  bool init=false;
  late InputAccountCon inputAccountCon;

  int cashNum;
  Function(String account) dismiss;
  InputAccountDialog({
    required this.cashNum,
    required this.dismiss,
  });


  @override
  Widget build(BuildContext context){
    if(!init){
      inputAccountCon=Get.put(InputAccountCon());
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: (){
              var node = FocusScope.of(context);
              if(!node.hasPrimaryFocus&&node.focusedChild!=null){
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: _contentWidget(),
          ),
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
              back();
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
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpText(text: "\$$cashNum", size: 22.sp, color: "#009220"),
              SizedBox(height: 4.h,),
              _inputWidget(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 25.w,right: 25.w,top: 12.h,bottom: 28.h),
                child: QpText(text: "Your cash will arrive in your account within 3-7 business days. Please keep an eye on your account!", size: 13.sp, color: "#467777"),
              ),
              InkWell(
                onTap: (){
                  inputAccountCon.clickCash(dismiss);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    QpText(text: "Withdraw Now", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
                  ],
                ),
              ),
              SizedBox(height: 48.h,),
            ],
          ),
        )
      ],
    ),
  );

  _inputWidget()=>Container(
    width: double.infinity,
    height: 48.h,
    alignment: Alignment.center,
    margin: EdgeInsets.only(left: 22.w,right: 22.w),
    decoration: BoxDecoration(
      color: "#C6DDDD".toColor(),
      borderRadius: BorderRadius.circular(8.w),
    ),
    child: TextField(
      enabled: true,
      maxLength: 20,
      textAlign: TextAlign.center,
      controller: inputAccountCon.editingController,
      style: TextStyle(
        fontSize: 16.sp,
        color: "#137088".toColor(),
      ),
      decoration: InputDecoration(
        counterText: '',
        isCollapsed: true,
        hintText: "Please input your account",
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: "#137088".toColor().withAlpha((255.0 * 0.5).round()),
        ),
        border: InputBorder.none,
      ),
    ),
  );
}