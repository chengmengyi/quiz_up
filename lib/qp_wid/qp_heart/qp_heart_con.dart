import 'package:get/get.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class QpHeartCon extends GetxController implements EventListener{
  var userHeart=0;
  late ReceiveEvent receiveEvent;

  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _updateHeart();
  }

  @override
  receivedEvent(SendEvent event) {
    if(event.code==EventCode.updateHeart){
      _updateHeart();
    }
  }

  _updateHeart()async{
    userHeart = await ASql.instance.getUserInfo(UserInfoKey.heart);
    update(["heart"]);
  }

  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}