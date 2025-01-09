import 'package:get/get.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';

class QpMoneyCon extends GetxController implements EventListener{
  late ReceiveEvent receiveEvent;

  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  receivedEvent(SendEvent event) {
    switch(event.code){
      case EventCode.updateUserMoney:
        update(["money"]);
        break;
    }
  }

  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}