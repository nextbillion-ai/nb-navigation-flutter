//
//  NavigationLauncherHandler.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/7/5.
//

import Foundation
import Flutter
import NbmapNavigation
import NbmapCoreNavigation

class NavigationLauncherHandler: MethodChannelHandler {
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
        case MethodID.NAVIGATION_LAUNCH_NAVIGATION:
            guard let args = call.arguments as? [String : Any] else {
                return
            }

            let routes = Convert.convertNavigationOptions(arguments: args)
            if routes.isEmpty {
                return
            }
            var simulate = SimulationMode.onPoorGPS
            var enableDissolvedRoute = true
            var navigationModeStyle: [NbmapNavigation.Style] = [NavStyleManager.customDayStyle, NavStyleManager.customNightStyle]

            if let config = args["launcherConfig"] as? [String : Any] {
                if let isSimulate = config["shouldSimulateRoute"] as? Bool {
                    simulate = isSimulate ? .always : .onPoorGPS
                }
                if let dissolvedRoute = config["enableDissolvedRouteLine"] as? Bool {
                    enableDissolvedRoute = dissolvedRoute
                }
                if let themeMode = config["themeMode"] as? String, let useCustom = config["useCustomNavigationStyle"] as? Bool {
                    let navigationDayStyle = dayStyle(useCustom)
                    let navigationNightStyle = nightStyle(useCustom)
                    
                    if let mapStyleUrl = config["navigationMapStyleUrl"] as? String {
                        navigationDayStyle.mapStyleURL = URL(string: mapStyleUrl)!
                    }
                    
                    navigationModeStyle =
                    themeMode == "light" ? [navigationDayStyle] :
                    themeMode == "dark" ? [navigationNightStyle] :
                    [navigationDayStyle, navigationNightStyle]
                }
            }
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            let navigationService = NBNavigationService(routes: routes, routeIndex: 0, simulating: simulate)
            
            let navigationOptions = NavigationOptions(styles: navigationModeStyle, navigationService: navigationService)
            
            let navigationViewController = NavigationViewController(for: routes, navigationOptions: navigationOptions)
            navigationViewController.modalPresentationStyle = .fullScreen
            navigationViewController.routeLineTracksTraversal = enableDissolvedRoute
            viewController?.present(navigationViewController, animated: true)
        default:
            break
        }
    }
    
    func dayStyle(_ useCustomNavigationStyle: Bool) -> Style {
        return useCustomNavigationStyle ? NavStyleManager.customDayStyle : DayStyle()
    }
    
    func nightStyle(_ useCustomNavigationStyle: Bool) -> Style {
        return useCustomNavigationStyle ? NavStyleManager.customNightStyle : NightStyle()
    }
    
}
