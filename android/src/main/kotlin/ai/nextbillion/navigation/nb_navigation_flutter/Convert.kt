
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
    fun convertRequestParams(arguments: Any, builder: RouteRequestParams.Builder) {
        val data = arguments as Map<*, *>

        val baseUrl = data["baseUrl"] as? String
        baseUrl?.let {
            builder.baseUrl(it)
        }

        val mode = data["mode"] as? String
        mode?.let {
            builder.mode(it)
        }

        val points = data["waypoints"] as? List<*>
        if (!points.isNullOrEmpty()) {
            val wayPoints = mutableListOf<Point>()
            points.forEach {
                val point = it as Map<*, *>
                val wayPoint = Point.fromLngLat(point["longitude"] as Double, point["latitude"] as Double)
                wayPoints.add(wayPoint)
            }
            builder.waypoints(wayPoints)
        }

        val origin = data["origin"] as? Map<*, *>
        val destination = data["destination"] as? Map<*, *>
        if (origin != null && destination != null) {
            val originPoint = Point.fromLngLat(origin["longitude"] as Double, origin["latitude"] as Double)
            val destinationPoint = Point.fromLngLat(destination["longitude"] as Double, destination["latitude"] as Double)
            builder.origin(originPoint)
            builder.destination(destinationPoint)
        }

        val alternatives = data["alternatives"] as? Boolean
        alternatives?.let {
            builder.alternatives(it)
        }

        val altCount = data["altCount"] as? Int
        altCount?.let {
            builder.altCount(it)
        }

        val language = data["language"] as? String
        language?.let {
            builder.language(it)
        }

        val geometry = data["geometry"] as? String
        geometry?.let {
            builder.geometry(it)
        }

        val geometryType = data["geometryType"] as? String
        geometryType?.let {
            builder.geometryType(it)
        }

        val overview = data["overview"] as? String
        overview?.let {
            builder.overview(it)
        }

        val annotations = data["annotations"] as? String
        annotations.let {
            builder.annotations(it)
        }

        val key = data["key"] as? String
        key?.let {
            builder.key(it)
        }

        val avoid = data["avoid"] as? List<String>
        avoid?.let {
            builder.avoid(it)
        }

        val unit = data["unit"] as? String
        unit?.let {
            builder.unit(it)
        }

        val departureTime = data["departureTime"] as? Int
        departureTime?.let {
            builder.departureTime(departureTime)
        }


//        val approaches = data["approaches"] as String
//        if (!TextUtils.isEmpty(approaches)) {
//            builder.approaches(approaches)
//        }

        val truckSize = data["truckSize"] as? List<*>
        truckSize?.let { list ->
            builder.truckSize(list.map { it.toString() })
        }

        val truckWeight = data["truckWeight"] as? Int
        truckWeight?.let {
            builder.truckWeight(it)
        }

        val simulation = data["simulation"] as? Boolean
        simulation?.let {
            builder.simulation(it)
        }

        val option = data["option"] as? String
        if (!TextUtils.isEmpty(option)) {
            builder.option(option)
        }

    }

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