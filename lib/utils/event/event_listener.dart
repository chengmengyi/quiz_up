import 'package:quiz_up/utils/event/send_event.dart';

abstract class EventListener{
  receivedEvent(SendEvent event);
}