import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/utils/utils.dart';

class TestCon extends GetxController{

}

class Test extends StatelessWidget{
  bool init=false;
  late TestCon answerRightCon;

  @override
  Widget build(BuildContext context) {
    if(!init){
      answerRightCon=Get.put(TestCon());
      init=true;
    }
    return Scaffold(
      body: SafeArea(
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
      ),
    );
  }

}