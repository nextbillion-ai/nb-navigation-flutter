part of nb_navigation_flutter;

class NBNavigation {
  static final NBNavigationPlatform _nbNavigationPlatform = NBNavigationPlatform.instance;

  /// Fetches a route based on the provided [routeRequestParams].
  /// The [routeResultCallBack] will be invoked with the result.
  static Future<void> fetchRoute(RouteRequestParams routeRequestParams,
      OnGetRouteResultCallBack routeResultCallBack) async {
    await _nbNavigationPlatform.fetchRoute(routeRequestParams, routeResultCallBack);
  }

  /// Starts the navigation using the provided [launcherConfig].
  static Future<void> startNavigation(NavigationLauncherConfig launcherConfig) async {
    await _nbNavigationPlatform.startNavigation(launcherConfig);
  }

  /// Finds the index of the selected route based on the [clickPoint] and [coordinates] of route line.
  /// Returns the index of the selected route.
  static Future<int> findSelectedRouteIndex(LatLng clickPoint, List<List<LatLng>> coordinates) async {
    return await _nbNavigationPlatform.findSelectedRouteIndex(clickPoint, coordinates);
  }
}