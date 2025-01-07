import 'package:get/get.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/receive_event.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';

class QpLevelCon extends GetxController implements EventListener{
  var userLevel=0;
  late ReceiveEvent receiveEvent;

  @override
  void onInit() {
    super.onInit();
    receiveEvent=ReceiveEvent(eventListener: this);
  }

  @override
  void onReady() {
    super.onReady();
    _updateLevel();
  }

  @override
  receivedEvent(SendEvent event) {
    if(event.code==EventCode.updateAnswerNum){
      _updateLevel();
    }
  }

  _updateLevel()async{
    var answerNum = await ASql.instance.getUserInfo(UserInfoKey.answerNum);
    userLevel=answerNum~/5;
    update(["level"]);
  }

  @override
  void onClose() {
    receiveEvent.cancel();
    super.onClose();
  }
}