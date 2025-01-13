import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_wid/qp_bubble/qp_bubble_con.dart';
import 'package:quiz_up/qp_wid/qp_gra_text.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';

class QpBubbleWidget extends StatelessWidget{
  bool _init=false;
  late QpBubbleCon qpBubbleCon;

  @override
  Widget build(BuildContext context) {
    if(!_init){
      qpBubbleCon=Get.put(QpBubbleCon());
      _init=true;
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      key: qpBubbleCon.globalKey,
      child: Stack(
        children: [
          GetBuilder<QpBubbleCon>(
            id: "pos",
            builder: (_)=>Positioned(
              top: qpBubbleCon.top,
              left: qpBubbleCon.left,
              child: Visibility(
                visible: qpBubbleCon.showBubble,
                child: InkWell(
                  onTap: (){
                    qpBubbleCon.clickBubble();
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      QpImg(img: "bubble",width: 74.w,height: 74.w,),
                      QpGraText(
                        text: "+\$${qpBubbleCon.addNum}",
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
              ),
            ),
          )
        ],
      ),
    );
  }
}