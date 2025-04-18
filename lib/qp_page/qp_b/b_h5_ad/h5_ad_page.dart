import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_b/b_h5_ad/b_h5_ad_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_lottie.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class H5AdPage extends StatelessWidget{
  final H5AdCon _h5adCon=Get.put(H5AdCon());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
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
                  SizedBox(height: 12.h,),
                  Expanded(
                    child: GetBuilder<H5AdCon>(
                      id: "content",
                      builder: (_)=>_h5adCon.showLoading?
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: "#FFFFFF".toColor(),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(color: Colors.black,),
                      )
                          :Stack(
                        children: [
                          WebViewWidget(
                            controller: _h5adCon.webViewController,
                          ),
                          _coverWidget(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onWillPop: ()async{
          return false;
        },
      ),
    );
  }

  _titleWidget()=>Row(
    children: [
      SizedBox(width: 16.w,),
      GetBuilder<H5AdCon>(
        id: "close_btn",
        builder: (_)=>Visibility(
          visible: _h5adCon.showCloseBtn,
          child: InkWell(
            onTap: (){
              QpRouters.back(result: {});
            },
            child: QpImg(img: "icon_close1",width: 30.w,height: 30.h,),
          ),
        ),
      ),
      SizedBox(width: 10.w,),
      QpText(text: "Earn Reward by Watching", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
    ],
  );

  _coverWidget()=>GetBuilder<H5AdCon>(
    id: "cover",
    builder: (_)=>Visibility(
      visible: _h5adCon.showCover,
      child: InkWell(
        onTap: (){
          _h5adCon.clickCover();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: "#000000".toColor().withOpacity(0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpLottie(name: "finger",width: 120.w,height: 120.h,),
              QpText(text: "Tap to claim a bigger reward!", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,)
            ],
          ),
        ),
      ),
    ),
  );
}