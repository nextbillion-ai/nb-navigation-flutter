part of nb_navigation_flutter;

class MethodChannelNBNavigation extends NBNavigationPlatform {
  final MethodChannel _channel = NBNavigationChannelFactory.nbNavigationChannel;

  MethodChannelNBNavigation() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case NBNavigationLauncherMethodID.nbOnNavigationExit:
        var arguments = call.arguments;
        bool? shouldRefreshRoute = arguments["shouldRefreshRoute"];
        int? remainingWaypoints = arguments["remainingWaypoints"];
        if (shouldRefreshRoute != null && remainingWaypoints != null) {
          navigationExitCallback?.call(arguments["shouldRefreshRoute"], arguments["remainingWaypoints"]);
        }
        break;

      default:
        throw MissingPluginException();
    }
  }

  @override
  Future<List<DirectionsRoute>> fetchRoute(RouteRequestParams routeRequestParams) async {
    try {
      Map<dynamic, dynamic> result = await _channel.invokeMethod(NBRouteMethodID.nbFetchRouteMethod, jsonEncode(routeRequestParams));
      return _handleRouteResult(result);
    } catch (e) {
      rethrow;
    }
  }

  List<DirectionsRoute> _handleRouteResult(Map<dynamic, dynamic> result) {
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

    if (error.isNotEmpty) {
      throw Exception(error);
    }

    return routes;
  }

  @override
  Future<void> startNavigation(NavigationLauncherConfig launcherConfig) async {
    try {
      Map<String, dynamic> arguments = {};
      if (Platform.isIOS) {
        arguments["routeOptions"] = jsonEncode(launcherConfig.route.routeOptions);
      }
      arguments["launcherConfig"] = launcherConfig.toJson();
      await _channel.invokeMethod(NBNavigationLauncherMethodID.nbNavigationLauncherMethod, arguments);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> startPreviewNavigation(DirectionsRoute route) async {
    try {
      Map<String, dynamic> arguments = {};
      if (Platform.isIOS) {
        arguments["routeOptions"] = jsonEncode(route.routeOptions);
      }
      arguments["route"] = jsonEncode(route);
      await _channel.invokeMethod(NBNavigationLauncherMethodID.nbPreviewNavigationMethod, arguments);
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

  @override
  Future<String> getFormattedDuration(num durationSeconds) async {
    try {
      return await _channel.invokeMethod(NBRouteMethodID.routeFormattedDuration, {"duration": durationSeconds.toDouble()});
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return "";
  }

  @override
  Future<void> setOnNavigationExitCallback(OnNavigationExitCallback navigationExitCallback) async {
    try {
      this.navigationExitCallback = navigationExitCallback;
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
