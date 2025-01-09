import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/new_user/new_user_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class NewUserDialog extends StatelessWidget{
  Function() dismiss;
  NewUserDialog({required this.dismiss});
  bool init=false;
  late NewUserCon newUserCon;

  @override
  Widget build(BuildContext context) {
    if(!init){
      newUserCon=Get.put(NewUserCon());
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _addWidget(),
              _myCashWidget(),
              _cashBtnWidget(),
            ],
          ),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }
  
  _addWidget()=>QpText(text: "+\$${ValueUtils.instance.getNewUserAdd()}", size: 32.sp, color: "#FFD322",fontWeight: FontWeight.w800,);

  _myCashWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      QpText(text: "My Cash:", size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
      QpText(text: "\$${ValueUtils.instance.getNewUserAdd()}", size: 18.sp, color: "#F81B4C",fontWeight: FontWeight.w800,),
    ],
  );

  _cashBtnWidget()=>InkWell(
    onTap: (){
      newUserCon.clickCash(dismiss);
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QpImg(img: "btn2",width: 228.w,height: 60.h,),
        QpText(text: "Withdraw", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
      ],
    ),
  );
}