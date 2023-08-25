part of nb_navigation_flutter;

class MethodChannelNBNavigation extends NBNavigationPlatform {
  final MethodChannel _channel = NBNavigationChannelFactory.nbNavigationChannel;

  @override
  Future<void> fetchRoute(RouteRequestParams routeRequestParams, OnGetRouteResultCallBack routeResultCallBack) async {
    onGetRouteResultCallBack = routeResultCallBack;
    try {
      Map<dynamic, dynamic> result = await _channel.invokeMethod(NBRouteMethodID.nbFetchRouteMethod, routeRequestParams.toJson());
      _handleRouteResult(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void _handleRouteResult(Map<dynamic, dynamic> result) {
    List<String> routeJson = List<String>.from(result["routeResult"] ?? []);
    String error = result["error"] ?? "";
    Map<dynamic, dynamic> routeRequest = result["routeOptions"] ?? {};
    RouteRequestParams? requestParams;

    if (routeRequest.isNotEmpty) {
      requestParams = RouteRequestParams.fromJson(json.decode(json.encode(routeRequest)));
    }

    List<DirectionsRoute> routes = [];
    if (routeJson.isNotEmpty) {
      for (var json in routeJson) {
        DirectionsRoute route = DirectionsRoute.fromJson(jsonDecode(json));
        if (requestParams != null) {
          route.routeOptions = requestParams;
        }
        routes.add(route);
      }
    }

    if (onGetRouteResultCallBack != null) {
      onGetRouteResultCallBack!(routes, error);
    }
  }

  @override
  Future<void> startNavigation(NavigationLauncherConfig launcherConfig) async {
    try {
      Map<String, dynamic> arguments = {};
      if (Platform.isIOS) {
        arguments["routeOptions"] = launcherConfig.route.routeOptions?.toJson();
      }
      arguments["launcherConfig"] = launcherConfig.toJson();
      await _channel.invokeMethod(NBNavigationLauncherMethodID.nbNavigationLauncherMethod, arguments);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<int> findSelectedRouteIndex(LatLng clickPoint, List<List<LatLng>> coordinates) async {
    Map<String, dynamic> arguments = {};
    arguments["clickPoint"] = clickPoint.toJson();
    arguments["coordinates"] =
        coordinates.map((coordinate) => coordinate.map((point) => point.toJson()).toList()).toList();
    return await _channel.invokeMethod(NBRouteMethodID.nbRouteSelectedIndexMethod, arguments);
  }

  @override
  Future<String> getRoutingBaseUri() async {
    return await _channel.invokeMethod(NBNavigationLauncherMethodID.nbGetNavigationUriMethod);
  }

  @override
  Future<void> setRoutingBaseUri(String baseUri) async {
    Map<String, dynamic> arguments = {};
    arguments["navigationBaseUri"] = baseUri;
    try {
      await _channel.invokeMethod(NBNavigationLauncherMethodID.nbSetNavigationUriMethod, arguments);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
