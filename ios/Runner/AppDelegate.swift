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

        let channel = FlutterEventChannel(name: "get_battery_event", binaryMessenger: controller.binaryMessenger)
        channel.setStreamHandler(EventHandler.eventHandlerInstance)

        let nativeViewFactory = FLNativeViewFactory(messenger: controller.binaryMessenger)
        self.registrar(forPlugin: "SwiftUIView")!.register(
            nativeViewFactory,
            withId: "MySwiftUIView"
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class EventHandler: NSObject, FlutterStreamHandler {
    static var eventHandlerInstance = EventHandler()
    private var eventSink: FlutterEventSink?

    func setEventSink(_ sink: @escaping FlutterEventSink) {
        self.eventSink = sink
    }

    func sendEvent(_ eventData: Any) {
        if let eventSink = eventSink {
            eventSink(eventData)
        }
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen called")
        setEventSink(events)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel called")
        return nil
    }
}
