part of nb_navigation_flutter;

typedef OnGetRouteResultCallBack = void Function(List<DirectionsRoute> routes, String error);

abstract class NBNavigationPlatform {
  static final NBNavigationPlatform _instance = MethodChannelNBNavigation();

  static NBNavigationPlatform get instance => _instance;
  OnGetRouteResultCallBack? onGetRouteResultCallBack;

  Future<void> fetchRoute(RouteRequestParams routeRequestParams, OnGetRouteResultCallBack routeResultCallBack);

  Future<void> startNavigation(NavigationLauncherConfig launcherConfig);

  Future<int> findSelectedRouteIndex(LatLng clickPoint, List<List<LatLng>> coordinates);
}
