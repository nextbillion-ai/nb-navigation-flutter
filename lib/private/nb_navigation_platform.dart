part of nb_navigation_flutter;

typedef OnGetRouteResultCallBack = void Function(List<DirectionsRoute> routes, String error);

typedef OnNavigationExitCallback = void Function(bool shouldRefreshRoute, int remainingWaypoints);

abstract class NBNavigationPlatform {
  static final NBNavigationPlatform _instance = MethodChannelNBNavigation();

  static NBNavigationPlatform get instance => _instance;
  OnGetRouteResultCallBack? onGetRouteResultCallBack;

  OnNavigationExitCallback? navigationExitCallback;

  Future<void> fetchRoute(RouteRequestParams routeRequestParams, OnGetRouteResultCallBack routeResultCallBack);

  Future<void> startNavigation(NavigationLauncherConfig launcherConfig);

  Future<void> startPreviewNavigation(DirectionsRoute route);

  Future<String> getRoutingBaseUri();

  Future<void> setRoutingBaseUri(String baseUri);

  Future<int> findSelectedRouteIndex(LatLng clickPoint, List<List<LatLng>> coordinates);

  Future<String> getFormattedDuration(num durationSeconds);

  Future<void> setOnNavigationExitCallback(OnNavigationExitCallback navigationExitCallback);

}
