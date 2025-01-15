import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quiz_up/utils/local_notifications/local_notification_id.dart';
import 'package:quiz_up/utils/utils.dart';

class LocalNotificationsUtils {
  static final LocalNotificationsUtils _utils=LocalNotificationsUtils();
  static LocalNotificationsUtils get instance=>_utils;

  var flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  setLocalNotifications()async{
    var success = await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (
          NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            // _clickNotification(notificationResponse);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // _clickNotification(notificationResponse);
            break;
        }
      },
    );
    if(success==true){
      _showRegularNotification();
      _showSignNotification();
      _showQuizNotification();
      _showPayNotification();
    }
    _checkPermission();
  }

  _showRegularNotification(){
    flutterLocalNotificationsPlugin.periodicallyShow(
      LocalNotificationId.regularId,
      "Earn money by QuizTime",
      ["💰More than 1,000 users have successfully withdrawn money","🎁Turn your knowledge into cash","🔥Here‘s \$100 for you! Expired after 5 minutes!"].random(),
      RepeatInterval.daily,
      NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  _showSignNotification()async{
    await Future.delayed(Duration(seconds: 10));
    flutterLocalNotificationsPlugin.periodicallyShow(
      LocalNotificationId.signId,
      "Cash in check daily",
      "Sign up now and start earning money effortlessly.",
      RepeatInterval.hourly,
      NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  _showQuizNotification()async{
    await Future.delayed(Duration(seconds: 20));
    flutterLocalNotificationsPlugin.periodicallyShow(
      LocalNotificationId.quizId,
      "Answer right, Earn Big!",
      ["💰Someone just made a successful withdrawal on QuizTime！","🎁Put your knowledge to work and earn money!"].random(),
      RepeatInterval.hourly,
      NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  _showPayNotification()async{
    await Future.delayed(Duration(seconds: 10));
    flutterLocalNotificationsPlugin.periodicallyShow(
      LocalNotificationId.payId,
      "Pending withdraw amount",
      "\$100 has arrived in your account",
      RepeatInterval.daily,
      NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  _checkPermission()async{
    var plugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    var options = await plugin?.checkPermissions();
    if(options?.isEnabled!=true){

    }
  }
}