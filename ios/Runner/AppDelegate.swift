import Flutter
import UIKit
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

   if let flutterController = window?.rootViewController as? FlutterViewController {
              let methodChannel = FlutterMethodChannel(name: "com.quizup.find.rightanswer.h5", binaryMessenger: flutterController.binaryMessenger)
              let flutterView = flutterController.view;
              if let flutterView = flutterView {
                  let ssss = FaCIXmVKefVqVbeL.ymvLeDf()
                  ssss.faCIXmVKefVqVbeLQcqRnbhneu(flutterController, mVKehneu: flutterView)
                  ssss.mVKeGcnqHOdcCI = { quizX, quizY in
                      methodChannel.invokeMethod("quiz_h5_method", arguments: ["quizX": quizX, "quizY": quizY])
                  }

                  methodChannel.setMethodCallHandler { call, result in
                      if (call.method == "pageA") {
                          ssss.faCIXmVKefVqVbeLyeKcrehneu8()
                      }

                      if (call.method == "pageB1") {
                          ssss.faCIXmVKefVqVbeLOVvnCQcqRnb()
                      }

                      if (call.method == "pageB2") {
                          ssss.faCIXmVKefVqVbeLhneu8QcqRnb()
                      }

                      if (call.method == "clickH5") {
                          ssss.faCIXmVKefVqVbeLhneu6QcqRnb()
                      }
                  }
              }
          }


     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
              GeneratedPluginRegistrant.register(with: registry)
          }

          if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
          }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
