//
//  FLNativeView.swift
//  Runner
//
//  Created by Vashist Agarwalla on 15/12/23.
//

import Flutter
import SwiftUI
import UIKit

/// A Flutter platform view factory for creating native views in Flutter.
///
/// The `FLNativeViewFactory` class implements `FlutterPlatformViewFactory` and is responsible for
/// creating instances of the `FLNativeView` class. It integrates the Flutter framework with a native
/// iOS view, allowing the rendering of a SwiftUI view (`SwiftUIView`) within a Flutter application.
///
class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

/// A Flutter platform view representing a native view in Flutter.
///
/// The `FLNativeView` class implements `FlutterPlatformView` and contains the logic for creating and
/// managing a native view in a Flutter application. It integrates a SwiftUI view (`SwiftUIView`) within
/// the native view hierarchy, allowing seamless interoperability between Flutter and SwiftUI.
///
class FLNativeView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) {
        containerView = UIView()
        super.init()
        createNativeView(view: containerView, arguments: args)
    }
    
    func createNativeView(view containerView: UIView, arguments args: Any?) {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
              let topController = keyWindow.rootViewController else {
            return
        }
        
        let hostingController = UIHostingController(rootView: SwiftUIView())
        
        let hostingView = hostingController.view!
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        topController.addChild(hostingController)
        containerView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: topController)
    }
    
    func view() -> UIView {
        return containerView
    }
}
