//
//  MethodHandleFactory.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/7/5.
//

import Foundation
import Flutter

class MethodHandleFactory: NSObject {
    
    static let shared = MethodHandleFactory()
    
    var nbNavigationHandler: NBNavigationHandler = NBNavigationHandler()
    var routeFetchHandler: RouteFetcherHandler = RouteFetcherHandler()
    var navigationLauncherHandler: NavigationLauncherHandler = NavigationLauncherHandler()
    
    
    func dispatchMethodHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        var methodChannelHandler: MethodChannelHandler?
        
        switch call.method {
        case MethodID.NAVIGATION_FETCH_ROUTE, MethodID.NAVIGATION_FIND_SELECTED_ROUTE:
            methodChannelHandler = routeFetchHandler
            
        case MethodID.NAVIGATION_LAUNCH_NAVIGATION:
            methodChannelHandler = navigationLauncherHandler
            
        case MethodID.NAVIGATION_INIT_NAVIGATION, MethodID.NAVIGATION_GET_ACCESS_KEY:
            methodChannelHandler = nbNavigationHandler
            
        default:
            break
        }
        methodChannelHandler?.handleMethodCallResult(call: call, result: result)
        
    }
    
}
