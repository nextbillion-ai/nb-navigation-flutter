package ai.nextbillion.navigation.nb_navigation_flutter

import ai.nextbillion.kits.directions.models.DirectionsResponse
import ai.nextbillion.kits.directions.models.RouteRequestParams
import ai.nextbillion.kits.geojson.Point
import ai.nextbillion.kits.turf.TurfConstants
import ai.nextbillion.kits.turf.TurfMeasurement
import ai.nextbillion.kits.turf.TurfMisc
import ai.nextbillion.navigation.core.routefetcher.RouteFetcher
import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

/**
 * @author qiuyu
 * @Date 2023/3/7
 **/
class RouteFetcherHandler : MethodChannelHandler() {

    init {
        methodChannel = MethodChannelManager.getInstance().navigationChannel
    }


    override fun handleMethodCallResult(activity: Activity?, call: MethodCall?, result: MethodChannel.Result?) {
        super.handleMethodCallResult(activity, call, result)
        if (methodChannel == null || call == null || result == null) {
            return
        }

        when (call.method) {
            MethodID.NAVIGATION_FETCH_ROUTE -> {
                fetchRoute(call, result)
            }
            MethodID.NAVIGATION_FIND_SELECTED_ROUTE -> {
                findSelectedRouteIndex(call, result)
            }

        }
    }

    private fun findSelectedRouteIndex(call: MethodCall, result: MethodChannel.Result) {
        val data = call.arguments as Map<*, *>
        val clicked: List<Double> = data["clickPoint"] as List<Double>
        val clickedPoint = Point.fromLngLat(clicked[1], clicked[0])
        val coordinates: List<List<List<Double>>> = data["coordinates"] as List<List<List<Double>>>
        val routeDistancesAwayFromClick = HashMap<Double, Int>()

        for (index in coordinates.indices) {
            val coords = coordinates[index]
            val points = arrayListOf<Point>()
            for (coord in coords) {
                val point = Point.fromLngLat(coord[1], coord[0])
                points.add(point)
            }
            val pointOnLine = findPointOnLine(clickedPoint, points)
            pointOnLine?.let {
                val distance = TurfMeasurement.distance(clickedPoint, pointOnLine, TurfConstants.UNIT_METERS)
                routeDistancesAwayFromClick.put(distance, index)
            }
        }

        val distancesAwayFromClick: List<Double> = routeDistancesAwayFromClick.keys.sorted()
        if (distancesAwayFromClick.isNotEmpty()) {
            val routeIndex = routeDistancesAwayFromClick[distancesAwayFromClick[0]]
            result.success(routeIndex)
        }
    }

    private fun findPointOnLine(clickPoint: Point, points: List<Point>): Point? {
        val feature = TurfMisc.nearestPointOnLine(clickPoint, points)
        return feature.geometry() as Point?
    }

    private fun fetchRoute(call: MethodCall, result: MethodChannel.Result) {
        val data = call.arguments as? Map<*, *>
        if (data == null || data.isEmpty()) {
            return
        }
        val params = RouteRequestParams.fromJson(data.toString())
        RouteFetcher.getRoute(params, object : Callback<DirectionsResponse> {
            override fun onResponse(call: Call<DirectionsResponse>, response: Response<DirectionsResponse>) {
                val args = mutableMapOf<String, Any>()
                if (response.code() >= 200 && response.code() < 300) {
                    val routes = response.body()?.routes()
                    if (!routes.isNullOrEmpty()) {
                        val routeArray = mutableListOf<String>()
                        for (route in routes) {
                            routeArray.add(route.toJson())
                        }
                        args["routeResult"] = routeArray
                    }
                } else {
                    args["error"] = response.code().toString()
                }
                result.success(args)

            }

            override fun onFailure(call: Call<DirectionsResponse>, t: Throwable) {
                val args = mutableMapOf<String,String>()
                args["error"] = t?.message ?: "Request failed"
                result.success(args)
            }

        })


    }

}