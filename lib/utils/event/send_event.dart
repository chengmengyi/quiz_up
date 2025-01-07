import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class SendEvent{
  int code;
  SendEvent({
    required this.code,
  });

  send(){
    eventBus.fire(this);
  }
}