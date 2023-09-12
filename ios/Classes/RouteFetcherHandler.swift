//
//  RouteFetcherHandler.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/7/5.
//

import Foundation
import Flutter
import NbmapDirections
import Turf

class RouteFetcherHandler: MethodChannelHandler {
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
        case MethodID.NAVIGATION_FETCH_ROUTE:
            guard let args = call.arguments as? String else {
                return
            }
            if let routeOptions = Convert.convertRouteRequestParams(arguments: args) {
                requestRoute(with: routeOptions, call: call, result: result)
            }
        case MethodID.NAVIGATION_FIND_SELECTED_ROUTE:
            guard let args = call.arguments as? [String : Any] else {
                return
            }
            guard let clicked = args["clickPoint"] as? [Double],
                  let coordinates = args["coordinates"] as? [[[Double]]] else {
                return
            }

            let tapCoordinate = CLLocationCoordinate2D(latitude: clicked[0], longitude: clicked[1])
            var lines: [[CLLocationCoordinate2D]] = []
            for line in coordinates {
                var coordinates: [CLLocationCoordinate2D] = []
                for coordinate in line {
                    let coord = CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1])
                    coordinates.append(coord)
                }
                lines.append(coordinates)
            }
            let closest = lines.sorted { (left, right) -> Bool in
                //existance has been assured through use of filter.
                let leftLine = Polyline(left)
                let rightLine = Polyline(right)
                let leftDistance = leftLine.closestCoordinate(to: tapCoordinate)!.distance
                let rightDistance = rightLine.closestCoordinate(to: tapCoordinate)!.distance
                
                return leftDistance < rightDistance
            }
            let candidates = closest.filter {
                let closestCoordinate = Polyline($0).closestCoordinate(to: tapCoordinate)!.coordinate
                return closestCoordinate.distance(to: tapCoordinate) < 5000
            }
            if !candidates.isEmpty, let routeIndex = lines.firstIndex(of: candidates.first!) {
                result(routeIndex)
            }
            
        default:
            break
        }
    }

    func requestRoute(with options: RouteOptions, call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        Directions.shared.calculate(options, completionHandler: {(potentialRoutes, potentialError) in
            if let error = potentialError {
                result(["error": error.toastError()])
            }
            
            guard let routes = potentialRoutes else { return }
            
            let routeResult = routes.map { route in
                return route.json
            }
            let routeOptions = Convert.convertRouteOptionsToMap(routeOptions: options)
            var args: [String: Any] = [:]
            args["routeResult"] = routeResult
            args["routeOptions"] = routeOptions
            result(args)
        })
    }
    
}
