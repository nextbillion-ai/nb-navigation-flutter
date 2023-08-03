
package ai.nextbillion.navigation.nb_navigation_flutter

import ai.nextbillion.kits.directions.models.DirectionsRoute
import ai.nextbillion.kits.directions.models.RouteRequestParams
import ai.nextbillion.kits.geojson.Point
import ai.nextbillion.maps.location.modes.RenderMode
import ai.nextbillion.navigation.ui.NavLauncherConfig
import android.text.TextUtils

/**
 * @author qiuyu
 * @Date 2023/2/23
 **/
object Convert {
    fun convertLauncherConfig(arguments: Map<*, *>): NavLauncherConfig.Builder? {
        val routesJson = arguments["routes"] as? List<*>
        if (!routesJson.isNullOrEmpty()) {
            val routes = routesJson.map { json -> DirectionsRoute.fromJson(json as String) }
            val configBuilder = NavLauncherConfig.builder(routes[0])
            configBuilder.routes(routes)

            val themeMode = arguments["themeMode"] as? String
            if (!TextUtils.isEmpty(themeMode)) {
                configBuilder.themeMode(themeMode)
            }

            val locationLayerRenderMode = arguments["locationLayerRenderMode"] as? Int
            if (locationLayerRenderMode != null) {
                val nbMapRenderModes = intArrayOf(RenderMode.NORMAL, RenderMode.COMPASS, RenderMode.GPS)
                configBuilder.locationLayerRenderMode(nbMapRenderModes[locationLayerRenderMode])
            }

            val shouldSimulateRoute = arguments["shouldSimulateRoute"] as? Boolean
            if (shouldSimulateRoute != null) {
                configBuilder.shouldSimulateRoute(shouldSimulateRoute)
            }

            val wayNameChipEnabled = arguments["wayNameChipEnabled"] as? Boolean
            if (wayNameChipEnabled != null) {
                configBuilder.waynameChipEnabled(wayNameChipEnabled)
            }

            val navigationMapStyle = arguments["navigationMapStyle"] as? String
            if (navigationMapStyle != null) {
                configBuilder.navigationMapStyle(navigationMapStyle)
            }

            val showSpeedometer = arguments["showSpeedometer"] as? Boolean
            if (showSpeedometer != null) {
                configBuilder.showSpeedometer(showSpeedometer)
            }

            val dissolvedRouteLineStyle = arguments["enableDissolvedRouteLine"] as? Boolean
            if (dissolvedRouteLineStyle != null) {
                configBuilder.dissolvedRouteLineStyle(if (dissolvedRouteLineStyle) 0 else 1)
            }

//            val maxNavCameraTilt = arguments["maxNavCameraTilt"] as? Float
//            if (maxNavCameraTilt != null) {
//                configBuilder.maxNavCameraTilt(maxNavCameraTilt)
//            }
//
//            val minNavCameraTilt = arguments["minNavCameraTilt"] as? Float
//            if (minNavCameraTilt != null) {
//                configBuilder.minNavCameraTilt(minNavCameraTilt)
//            }
//
//            val maxNavCameraZoom = arguments["maxNavCameraZoom"] as? Float
//            if (maxNavCameraZoom != null) {
//                configBuilder.maxNavCameraZoom(maxNavCameraZoom)
//            }
//
//            val minNavCameraZoom = arguments["minNavCameraZoom"] as? Float
//            if (minNavCameraZoom != null) {
//                configBuilder.minNavCameraZoom(minNavCameraZoom)
//            }
            return configBuilder
        }
        return null
    }
}