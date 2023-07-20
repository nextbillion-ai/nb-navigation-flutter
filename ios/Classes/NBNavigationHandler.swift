//
//  NBNavigationHandler.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/7/5.
//

import Foundation
import Flutter
import Nbmap

class NBNavigationHandler: MethodChannelHandler {
    override init() {
        super.init()
        methodChannel = MethodChannelManager.shared.navigationChannel
    }
    
    override func handleMethodCallResult(call: FlutterMethodCall?, result: @escaping FlutterResult) {
        super.handleMethodCallResult(call: call, result: result)
        
        guard let call = call else {
            return
        }
        
        switch call.method {
        case MethodID.NAVIGATION_INIT_NAVIGATION:
            guard let args = call.arguments as? [String : Any] else {
                return
            }
            if let accessKey = args["accessKey"] as? String {
                NGLAccountManager.accessToken = accessKey
            }
        default:
            break
        }
    }
    
}
