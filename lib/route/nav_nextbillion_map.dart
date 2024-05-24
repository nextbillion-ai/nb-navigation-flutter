part of nb_navigation_flutter;

typedef OnRouteSelectedCallback = void Function(int selectedRouteIndex);

class NavNextBillionMap {
  IMapController controller;
  IAssetManager assetManager = AssetManager();
  MapRouteLayerProvider routeLayerProvider = MapRouteLayerProvider();
  Map<String, LayerProperties> routeLayers = {};
  RouteLineProperties routeLineProperties;
  List<List<LatLng>> routeLines = [];
  OnRouteSelectedCallback? onRouteSelectedCallback;

  NavNextBillionMap._create(this.controller,
      {this.routeLineProperties = const RouteLineProperties()});

  static Future<NavNextBillionMap> create(IMapController mapController,
      {RouteLineProperties routeLineProperties = const RouteLineProperties()}) async {
    IAssetManager assetManager = AssetManager();
    return createWithAssetManager(mapController, assetManager,
        routeLineProperties: routeLineProperties);
  }

    static Future<NavNextBillionMap> createWithAssetManager(IMapController mapController, IAssetManager assetManager,
      {RouteLineProperties routeLineProperties = const RouteLineProperties()}) async {
    var navMap = NavNextBillionMap._create(mapController,
        routeLineProperties: routeLineProperties);
    navMap.assetManager = assetManager;
    await navMap.initGeoJsonSource();
    return navMap;
  }
  //

  Future<void> initGeoJsonSource() async {
    if (controller.disposed) {
      return;
    }
    await _removePreviousSource();
    await _addSource();
    await _loadAssetImage();
    await initRouteLayers();
    _addListeners();
  }

  Future<void> initRouteLayers() async {
    if (controller.disposed) {
      return;
    }
    String belowLayer = await controller.findBelowLayerId(
        [nbmapLocationId, highwayShieldLayerId, nbmapAnnotationId]);
    LineLayerProperties routeShieldLayer =
        routeLayerProvider.initializeRouteShieldLayer(
      routeLineProperties.routeScale,
      routeLineProperties.alternativeRouteScale,
      routeLineProperties.routeShieldColor,
      routeLineProperties.alternativeRouteShieldColor,
    );
    await controller.addLineLayer(
        routeShieldSourceId, routeShieldLayerId, routeShieldLayer,
        belowLayerId: belowLayer);
    routeLayers[routeShieldLayerId] = routeShieldLayer;

    LineLayerProperties routeLayer = routeLayerProvider.initializeRouteLayer(
      routeLineProperties.routeScale,
      routeLineProperties.alternativeRouteScale,
      routeLineProperties.routeDefaultColor,
      routeLineProperties.alternativeRouteDefaultColor,
    );
    await controller.addLineLayer(routeSourceId, routeLayerId, routeLayer,
        belowLayerId: belowLayer);
    routeLayers[routeLayerId] = routeLayer;

    SymbolLayerProperties wayPointLayer = routeLayerProvider
        .initializeWayPointLayer(originMarkerName, destinationMarkerName);
    await controller.addSymbolLayer(
        waypointSourceId, waypointLayerId, wayPointLayer);

    SymbolLayerProperties durationSymbolLayer =
        routeLayerProvider.initializeDurationSymbolLayer();
    await controller.addSymbolLayer(
        routeDurationSourceId, routeDurationLayerId, durationSymbolLayer,
        belowLayerId: nbmapWaynameLayer);
    routeLayers[routeDurationLayerId] = durationSymbolLayer;
  }

  /// Draws the route on the map based on the provided [routes].
  Future<void> drawRoute(List<DirectionsRoute> routes) async {
    if (controller.disposed) {
      return;
    }

    if (routes.isEmpty) {
      return;
    }

    await clearRoute();
    await _drawRoutesFeatureCollections(routes);
    await _drawWayPoints(routes.first);
    await _drawRouteDurationSymbol(routes);
  }

  /// Adds a listener for route selection.
  /// The [clickedPoint] represents the point clicked on the map.
  /// The [onRouteSelectedCallback] will be invoked when a route is selected.
  void addRouteSelectedListener(
      LatLng clickedPoint, OnRouteSelectedCallback onRouteSelectedCallback) {
    if (routeLines.length < 2) {
      return;
    }
    this.onRouteSelectedCallback = onRouteSelectedCallback;
    _findRouteSelectedIndex(clickedPoint);
  }

  Future<void> _drawRoutesFeatureCollections(
      List<DirectionsRoute> routes) async {
    if (controller.disposed) {
      return;
    }
    List<Map<String, dynamic>> routeLineFeatures = [];

    for (int i = 0; i < routes.length; i++) {
      DirectionsRoute route = routes[i];
      bool isPrimary = i == 0;

      List<LatLng> line =
          decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
      routeLines.add(line);
      LineOptions lineOptions = LineOptions(geometry: line);
      Map<String, dynamic> geoJson = Line("routeLine", lineOptions).toGeoJson();
      geoJson["properties"][primaryRoutePropertyKey] =
          isPrimary ? "true" : "false";
      routeLineFeatures.add(geoJson);
    }

    if (routeLineFeatures.isEmpty) {
      return;
    }

    List<Map<String, dynamic>> reversed = routeLineFeatures.reversed.toList();

    if (controller.disposed) {
      return;
    }

    await controller.setGeoJsonSource(
        routeShieldSourceId, buildFeatureCollection(reversed));
    await controller.setGeoJsonSource(
        routeSourceId, buildFeatureCollection(reversed));
  }

  int _getDecodePrecision(RouteRequestParams? routeOptions) {
    return routeOptions?.geometry == SupportedGeometry.polyline
        ? precision
        : precision6;
  }

  Future<void> _drawWayPoints(DirectionsRoute route) async {
    if (controller.disposed) {
      return;
    }

    List<Map<String, dynamic>> wayPoints = [];
    Coordinate origin = route.legs.first.steps!.first.maneuver!.coordinate!;
    Coordinate destination = route.legs.last.steps!.last.maneuver!.coordinate!;
    var originGeo = _generateWaypointSymbolGeo(origin, originMarkerName);
    wayPoints.add(originGeo);

    if (route.legs.length > 1) {
      for (int i = 0; i < route.legs.length - 1; i++) {
        Leg leg = route.legs[i];
        Coordinate? destination = leg.steps?.last.maneuver?.coordinate;
        if (destination != null) {
          String waypointName = "$destinationMarkerName${i + 1}";
          var wayPointGeo =
              _generateWaypointSymbolGeo(destination, waypointName);
          wayPoints.add(wayPointGeo);
          await _buildWaypointNumberView(waypointName, i + 1);
        }
      }
    }

    var desGeo = _generateWaypointSymbolGeo(destination, destinationMarkerName);
    wayPoints.add(desGeo);

    if (controller.disposed) {
      return;
    }

    await controller.setGeoJsonSource(
        waypointSourceId, buildFeatureCollection(wayPoints));
  }

  Map<String, dynamic> _generateWaypointSymbolGeo(
      Coordinate coordinate, String propertiesValue) {
    SymbolOptions coordinateSymbol = SymbolOptions(
        geometry: LatLng(coordinate.latitude, coordinate.longitude));
    Map<String, dynamic> coordinateGeo = coordinateSymbol.toGeoJson();
    coordinateGeo['properties'][waypointPropertyKey] = propertiesValue;
    return coordinateGeo;
  }

  Future<void> _buildWaypointNumberView(String waypointName, int index) async {
    if (controller.disposed) {
      return;
    }
    var image = await NBNavigation.captureRouteWaypoints(index);
    if (controller.disposed) {
      return;
    }
    if (image != null) {
      await controller.addImage(waypointName, image);
    }
  }

  Future<void> _drawRouteDurationSymbol(List<DirectionsRoute> routes) async {
    List<Map<String, dynamic>> durationSymbols = [];
    for (int i = 0; i < routes.length; i++) {
      DirectionsRoute route = routes[i];
      bool isPrimary = i == 0;
      List<LatLng> line =
          decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
      LatLng centerPoint = line[line.length ~/ 2];
      SymbolOptions durationSymbol = SymbolOptions(
          geometry: LatLng(centerPoint.latitude, centerPoint.longitude));
      Map<String, dynamic> geoJson = durationSymbol.toGeoJson();
      geoJson["properties"][primaryRoutePropertyKey] =
          isPrimary ? "true" : "false";
      String durationSymbolKey = "ROUTE_DURATION_SYMBOL_ICON_KEY$i";
      geoJson["properties"][routeDurationSymbolIconKey] = durationSymbolKey;
      durationSymbols.add(geoJson);
      await _setRouteDurationSymbol(durationSymbolKey, i, route);
    }
    if (controller.disposed) {
      return;
    }
    await controller.setGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection(durationSymbols));
  }

  Future<void> _setRouteDurationSymbol(
      String durationSymbolKey, int index, DirectionsRoute route) async {
    var image =
        await NBNavigation.captureRouteDurationSymbol(route, index == 0);
    if (controller.disposed) {
      return;
    }

    if (image != null) {
      controller.addImage(durationSymbolKey, image);
    }
  }

  /// Toggles the visibility of alternative routes on the map.
  /// The [alternativeVisible] parameter determines whether alternative routes should be visible or not.
  Future<void> toggleAlternativeVisibilityWith(bool alternativeVisible) async {
    if (controller.disposed) {
      return;
    }

    for (var entry in routeLayers.entries) {
      if (entry.key == routeShieldLayerId ||
          entry.key == routeLayerId ||
          entry.key == routeDurationLayerId) {
        if (alternativeVisible) {
          Platform.isIOS
              ? await controller
                  .setFilter(entry.key, ['<=', primaryRoutePropertyKey, 'true'])
              : await controller.setFilter(entry.key, ['literal', true]);
        } else {
          await controller
              .setFilter(entry.key, ['==', primaryRoutePropertyKey, 'true']);
        }
      }
    }
  }

  /// Toggles the visibility of the duration symbol on the map.
  /// The [durationSymbolVisible] parameter determines whether the duration symbol should be visible or not.
  void toggleDurationSymbolVisibilityWith(bool durationSymbolVisible) {
    if (controller.disposed) {
      return;
    }
    controller.setVisibility(routeDurationLayerId, durationSymbolVisible);
  }

  Future<void> _loadAssetImage() async {
    if (controller.disposed) {
      return;
    }
    var origin = await assetManager.load(routeLineProperties.originMarkerName);
    var destination =
        await assetManager.load(routeLineProperties.destinationMarkerName);
    if (controller.disposed) {
      return;
    }
    await controller.addImage(originMarkerName, origin);
    await controller.addImage(destinationMarkerName, destination);
  }

  Future<void> _addSource() async {
    if (controller.disposed) {
      return;
    }

    await controller.addGeoJsonSource(
        routeShieldSourceId, buildFeatureCollection([]));
    await controller.addGeoJsonSource(
        routeSourceId, buildFeatureCollection([]));
    await controller.addGeoJsonSource(
        waypointSourceId, buildFeatureCollection([]));
    await controller.addGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection([]));
  }

  Future<void> _removePreviousSource() async {
    if (controller.disposed) {
      return;
    }

    await controller.removeLayer(routeShieldLayerId);
    await controller.removeLayer(routeLayerId);
    await controller.removeLayer(waypointLayerId);
    await controller.removeLayer(routeDurationLayerId);

    await controller.removeSource(routeShieldSourceId);
    await controller.removeSource(routeSourceId);
    await controller.removeSource(waypointSourceId);
    await controller.removeSource(routeDurationSourceId);
  }

  /// Clears the currently displayed route from the map.
  Future<void> clearRoute() async {
    if (controller.disposed) {
      return;
    }
    await controller.setGeoJsonSource(
        routeShieldSourceId, buildFeatureCollection([]));
    await controller.setGeoJsonSource(
        routeSourceId, buildFeatureCollection([]));
    await controller.setGeoJsonSource(
        waypointSourceId, buildFeatureCollection([]));
    await controller.setGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection([]));
    routeLines.clear();
  }

  void _addListeners() {
    if (controller.disposed) {
      return;
    }
    controller.onFeatureTapped.add((id, point, coordinates) {
      if (id == "routeLine") {
        _findRouteSelectedIndex(coordinates);
      }
    });
  }

  void _findRouteSelectedIndex(LatLng clickedPoint) {
    if (routeLines.length < 2) {
      return;
    }
    NBNavigationPlatform.instance
        .findSelectedRouteIndex(clickedPoint, routeLines)
        .then((routeIndex) {
      if (onRouteSelectedCallback != null) {
        onRouteSelectedCallback!(routeIndex);
      }
    });
  }
}
