import 'dart:async';

import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/firebase_utils.dart';
import 'package:quiz_up/utils/h5_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class H5AdCon extends GetxController{
  var showCloseBtn=false,showCover=false,showLoading=true;
  late WebViewController webViewController;
  Timer? _closeBtnTimer;

  @override
  void onInit() {
    super.onInit();
    webViewController=WebViewController();
  }

  @override
  void onReady() {
    super.onReady();
    _checkShowCloseBtn();
    _getH5Url();
  }

  _checkShowCloseBtn(){
    if(FirebaseUtils.instance.h5CloseBtnShowTime<=0){
      showCloseBtn=true;
      update(["close_btn"]);
    }else{
      _closeBtnTimer=Timer(Duration(seconds: FirebaseUtils.instance.h5CloseBtnShowTime), (){
        showCloseBtn=true;
        update(["close_btn"]);
      });
    }
  }

  _getH5Url(){
    H5Utils.instance.clickH5(
      h5Call: (url){
        if(url.startsWith("http")){
          webViewController.loadRequest(Uri.parse(url));
          showCover=true;
          showLoading=false;
          update(["content"]);
        }else{
          QpRouters.back(result: {});
        }
      }
    );
  }

  clickCover(){
    showCover=false;
    update(["cover"]);
  }

  @override
  void onClose() {
    _closeBtnTimer?.cancel();
    _closeBtnTimer=null;
    super.onClose();
  }
}