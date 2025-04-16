import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/utils/utils.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
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