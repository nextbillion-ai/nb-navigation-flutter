//
//  Constants.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/7/5.
//

import Foundation

struct MethodID {
    static let NAVIGATION_FETCH_ROUTE = "route/fetchRoute"
    static let NAVIGATION_FIND_SELECTED_ROUTE = "route/findSelectedRouteIndex"
    static let NAVIGATION_LAUNCH_NAVIGATION = "navigation/startNavigation"
    static let NAVIGATION_INIT_NAVIGATION = "config/initNBNavigation"
    static let NAVIGATION_GET_ACCESS_KEY = "config/getAccessKey"
}

struct ResultID {
    static let NAVIGATION_ROUTE_RESULT = "route/routeResult"
}
