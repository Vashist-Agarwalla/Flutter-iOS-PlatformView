import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window?.rootViewController as! FlutterViewController
        
        let batteryChannel = FlutterMethodChannel(
            name: "battery_channel",
            binaryMessenger: controller.binaryMessenger
        )
    
        batteryChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getBatteryPercentage" {
                let batteryPercentage = BatteryObjectiveCClass.getBatteryPercentage()
                result(batteryPercentage)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        let nativeViewFactory = FLNativeViewFactory(messenger: controller.binaryMessenger)
        self.registrar(forPlugin: "SwiftUIView")!.register(
            nativeViewFactory,
            withId: "MySwiftUIView"
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
