import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let deepLinkChannel = FlutterMethodChannel(name: "com.hdi365.aqualife/deeplink",
                                                 binaryMessenger: controller.binaryMessenger)

      deepLinkChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
        // Additional handling if needed
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      if let controller = window?.rootViewController as? FlutterViewController {
        let deepLinkChannel = FlutterMethodChannel(name: "com.hdi365.aqualife/deeplink",
                                                   binaryMessenger: controller.binaryMessenger)

        // Send the full Universal Link URL to Flutter
        deepLinkChannel.invokeMethod("getDeepLink", arguments: url.absoluteString)
      }
    }
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}


// import UIKit
// import Flutter

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
