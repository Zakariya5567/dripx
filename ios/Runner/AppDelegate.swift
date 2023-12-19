import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let appVersionChannel = FlutterMethodChannel(name: "samples.flutter.dev/app_version", binaryMessenger: controller.binaryMessenger)
    appVersionChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getAppVersion" {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
//        let combinedVersion = "\(version)+\(buildNumber)"
        result(version)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
