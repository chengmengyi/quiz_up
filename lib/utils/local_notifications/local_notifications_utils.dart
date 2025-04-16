import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quiz_up/qp_dialog/dialog_b/open_notification/open_notification_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/local_notifications/local_notification_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
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
            _clickLocalNotification(notificationResponse.id);
            break;
          case NotificationResponseType.selectedNotificationAction:
            _clickLocalNotification(notificationResponse.id);
            break;
        }
      },
    );
    if(success==true){
      _showRegularNotification();
      _showSignNotification();
      _showQuizNotification();
      _showPayNotification();
    }else{
      _checkPermission();
    }
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
      QpRouters.showDialog(widget: OpenNotificationDialog());
    }else{
      PointUtils.instance.pointEvent(AppPointId.push_status);
    }
  }

  checkLaunchAppFrom()async{
    var launchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    PointUtils.instance.pointEvent(AppPointId.launch_page,data: {"source_from":launchDetails?.didNotificationLaunchApp==true?"push":"icon"});
    if(launchDetails?.didNotificationLaunchApp==true){
      _clickLocalNotification(launchDetails?.notificationResponse?.id);
    }
  }

  _clickLocalNotification(int? id){
    switch(id){
      case LocalNotificationId.regularId:
        PointUtils.instance.pointEvent(AppPointId.inform_c,data: {"inform_from":"regular"});
        break;
      case LocalNotificationId.payId:
        PointUtils.instance.pointEvent(AppPointId.inform_c,data: {"inform_from":"pay"});
        break;
      case LocalNotificationId.quizId:
        PointUtils.instance.pointEvent(AppPointId.inform_c,data: {"inform_from":"quiz"});
        break;
      case LocalNotificationId.signId:
        PointUtils.instance.pointEvent(AppPointId.inform_c,data: {"inform_from":"sign"});
        break;
    }
  }
}