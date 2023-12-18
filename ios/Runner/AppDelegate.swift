import UIKit
import Flutter

/// The main application delegate for the Flutter app.
/// Handles Flutter method calls, events, and plugin registration.
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Register Flutter plugins.
        GeneratedPluginRegistrant.register(with: self)
        
        // Get the Flutter view controller.
        let controller = window?.rootViewController as! FlutterViewController
        
        // Set up a Flutter method channel for handling battery-related method calls.
        let batteryChannel = FlutterMethodChannel(
            name: "battery_channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        // Handle method calls on the battery channel.
        batteryChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getBatteryPercentage" {
                // Call an Objective-C class method to get the battery percentage.
                let batteryPercentage = BatteryObjectiveCClass.getBatteryPercentage()
                result(batteryPercentage)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        // Set up a Flutter event channel for streaming battery-related events.
        let channel = FlutterEventChannel(name: "get_battery_event", binaryMessenger: controller.binaryMessenger)
        channel.setStreamHandler(EventHandler.eventHandlerInstance)

        // Register a custom Flutter view factory for displaying native views in Flutter.
        let nativeViewFactory = FLNativeViewFactory(messenger: controller.binaryMessenger)
        self.registrar(forPlugin: "SwiftUIView")!.register(
            nativeViewFactory,
            withId: "MySwiftUIView"
        )
        
        // Call the superclass method to complete app initialization.
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

/// Handles Flutter stream events and provides a singleton instance for event handling.
///
/// Example Usage:
///
/// ```swift
/// EventHandler.eventHandlerInstance.sendEvent("ButtonClickedEvent")
/// ```
class EventHandler: NSObject, FlutterStreamHandler {
    /// Singleton instance of the event handler.
    static var eventHandlerInstance = EventHandler()
    
    /// Stores the event sink for streaming events.
    private var eventSink: FlutterEventSink?

    /// Sets the event sink for streaming events.
    func setEventSink(_ sink: @escaping FlutterEventSink) {
        self.eventSink = sink
    }

    /// Sends an event through the event sink.
    func sendEvent(_ eventData: Any) {
        if let eventSink = eventSink {
            eventSink(eventData)
        }
    }

    /// Called when a Flutter listener starts listening to events.
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen called")
        setEventSink(events)
        return nil
    }

    /// Called when a Flutter listener cancels listening to events.
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel called")
        return nil
    }
}
