import 'dart:async';

import 'package:quiz_up/utils/event/event_listener.dart';
import 'package:quiz_up/utils/event/send_event.dart';

class ReceiveEvent{
  EventListener eventListener;
  late StreamSubscription<SendEvent> _streamSubscription;

  ReceiveEvent({
    required this.eventListener,
  }){
    _streamSubscription=eventBus.on<SendEvent>().listen((event) {
      eventListener.receivedEvent(event);
    });
  }

  cancel(){
    _streamSubscription.cancel();
  }
}