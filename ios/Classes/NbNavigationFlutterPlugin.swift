import Flutter
import UIKit
import NbmapDirections
import NbmapNavigation
import NbmapCoreNavigation
import Nbmap

public class NbNavigationFlutterPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "nb_navigation_flutter", binaryMessenger: registrar.messenger())
        MethodChannelManager.shared.navigationChannel = channel
        let instance = NbNavigationFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)

        let viewFactory = NBNavigationViewFactory(messenger: registrar.messenger())
           registrar.register(viewFactory, withId: "FlutterNBNavigationView")

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        MethodHandleFactory.shared.dispatchMethodHandler(call: call, result: result)
    }
    
}
