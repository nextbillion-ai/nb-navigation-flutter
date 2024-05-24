part of nb_navigation_flutter;

class NBNavigation {
  static NBNavigationPlatform _nbNavigationPlatform =
      NBNavigationPlatform.instance;

  @visibleForTesting
  static setNBNavigationPlatform(NBNavigationPlatform nbNavigationPlatform) {
    _nbNavigationPlatform = nbNavigationPlatform;
  }

  /// Fetches a route based on the provided [routeRequestParams].
  /// The [routeResultCallBack] will be invoked with the result.
  static Future<DirectionsRouteResponse> fetchRoute(
      RouteRequestParams routeRequestParams) async {
    return await _nbNavigationPlatform.fetchRoute(routeRequestParams);
  }

  /// Starts the navigation using the provided [launcherConfig].
  static Future<void> startNavigation(
      NavigationLauncherConfig launcherConfig) async {
    await _nbNavigationPlatform.startNavigation(launcherConfig);
  }

  /// get the base url for navigation related api
  static Future<String> getRoutingBaseUri() async {
    return await _nbNavigationPlatform.getRoutingBaseUri();
  }

  /// set the base url for navigation related api with the provided [baseUri]
  static Future<void> setRoutingBaseUri(String baseUri) async {
    await _nbNavigationPlatform.setRoutingBaseUri(baseUri);
  }

  /// Finds the index of the selected route based on the [clickPoint] and [coordinates] of route line.
  /// Returns the index of the selected route.
  static Future<int> findSelectedRouteIndex(
      LatLng clickPoint, List<List<LatLng>> coordinates) async {
    return await _nbNavigationPlatform.findSelectedRouteIndex(
        clickPoint, coordinates);
  }

  static Future<String> getFormattedDuration(num durationSeconds) async {
    return await _nbNavigationPlatform.getFormattedDuration(durationSeconds);
  }

  static Future<void> setOnNavigationExitCallback(
      OnNavigationExitCallback navigationExitCallback) async {
    return await _nbNavigationPlatform
        .setOnNavigationExitCallback(navigationExitCallback);
  }

  /// Start preview navigation screen with given route
  static Future<void> startPreviewNavigation(DirectionsRoute route) async {
    return await _nbNavigationPlatform.startPreviewNavigation(route);
  }

  static Future<Uint8List?> captureRouteDurationSymbol(
      DirectionsRoute route, bool isPrimaryRoute) async {
    return await _nbNavigationPlatform.captureRouteDurationSymbol(
        route, isPrimaryRoute);
  }

  static Future<Uint8List?> captureRouteWaypoints(int waypointIndex) async {
    return await _nbNavigationPlatform.captureRouteWaypoints(waypointIndex);
  }
}
