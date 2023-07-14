import UIKit
import Flutter

import flutter_local_notifcations


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FlutterLocalNotifcationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}

    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotifcationCenter.current().delegate = self as? UNUserNotifcationCenter
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
