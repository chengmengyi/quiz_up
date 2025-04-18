import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_up/bean/home_list_bean.dart';
import 'package:quiz_up/qp_page/qp_a/a_home/high_tips_overlay.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/h5_utils.dart';
import 'package:quiz_up/utils/overlay_utils.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class AHomeCon extends GetxController implements EventListener{
  List<HomeListBean> homeList=[
    HomeListBean(btn: "Easy>>", star: "star2",open: true),
    HomeListBean(btn: "Middle>>", star: "star3",open: true),
    HomeListBean(btn: "High>>", star: "star3",open: false),
  ];

  late ReceiveEvent receiveEvent;
  GlobalKey highGlobalKey=GlobalKey();

  @override
  void onInit() {
    super.onInit();
    H5Utils.instance.pageA();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _updateLock();
  }


  clickPlay(index,BuildContext context){
    if(index==2&&!homeList[index].open){
      var renderBox = highGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      OverlayUtils.instance.showOver(
        context: context,
        widget: HighTipsOverlay(offset: offset),
      );
      return;
    }
    QpRouters.toNamed(routersName: QpRouName.aWheel,arguments: {"index":index});
  }

  @override
  receivedEvent(SendEvent event) {
    if(event.code==EventCode.updateAnswerNum){
      _updateLock();
    }
  }

  _updateLock()async{
    var answerNum = await ASql.instance.getUserInfo(UserInfoKey.answerNum);
    var level = answerNum~/5;
    if(level>=8&&!homeList.last.open){
      homeList.last.open=true;
      update(["list"]);
    }
  }

  clickH5GameBtn(){
    H5Utils.instance.clickH5(
        h5Call: (url){
          QpRouters.toNamed(
            routersName: QpRouName.web,
            arguments: {"url":url},
          );
        }
    );
  }


  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}