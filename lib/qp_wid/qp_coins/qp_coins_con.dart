import 'package:get/get.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class QpCoinsCon extends GetxController implements EventListener{
  var userCoins=0;
  late ReceiveEvent receiveEvent;
  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _updateCoins();
  }

  @override
  receivedEvent(SendEvent event) {
    if(event.code==EventCode.updateCoins){
      _updateCoins();
    }
  }

  _updateCoins()async{
    userCoins = await ASql.instance.getUserInfo(UserInfoKey.coin);
    update(["coins"]);
  }

  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}