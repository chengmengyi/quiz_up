import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';

class LoadingDialog extends StatelessWidget{
  bool init=false;
  Function() dismiss;
  LoadingDialog({required this.dismiss});

  @override
  Widget build(BuildContext context) {
    if(!init){
      Future.delayed(Duration(milliseconds: 5000),(){
        back();
        dismiss.call();
      });
      init=true;
    }
    return WillPopScope(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: 100.w,
              height: 100.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: CircularProgressIndicator(color: Colors.white,),
            ),
          ),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }
}