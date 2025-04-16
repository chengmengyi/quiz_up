import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_wwwwbbbb/privacy_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QpWWWWWPage extends StatelessWidget{
  QpWWWWWCon qpWWWWWCon=Get.put(QpWWWWWCon());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      alignment: Alignment.topCenter,
      children: [
        QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
        SafeArea(
          top: true,
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _titleWidget(),
              SizedBox(height: 20.h,),
              Expanded(
                child: WebViewWidget(
                  controller: qpWWWWWCon.webViewController,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );

  _titleWidget()=>Row(
    children: [
      SizedBox(width: 16.w,),
      InkWell(
        onTap: (){
          QpRouters.back(result: {});
        },
        child: QpImg(img: "icon_close1",width: 30.w,height: 30.h,),
      ),
      SizedBox(width: 10.w,),
      // QpText(text: "Setting", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
    ],
  );
}