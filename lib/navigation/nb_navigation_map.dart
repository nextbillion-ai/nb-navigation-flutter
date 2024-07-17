part of nb_navigation_flutter;

typedef OnRouteSelectedCallback = void Function(int selectedRouteIndex);

class NavNextBillionMap implements NavigationMap {
  late MapController controller;
  late IAssetManager assetManager;

  MapRouteLayerProvider routeLayerProvider = MapRouteLayerProvider();
  Map<String, LayerProperties> routeLayers = {};

  RouteLineProperties routeLineProperties;
  List<List<LatLng>> routeLines = [];

  OnRouteSelectedCallback? onRouteSelectedCallback;

  NavNextBillionMap._create(this.controller,
      {this.routeLineProperties = const RouteLineProperties()});

  static Future<NavNextBillionMap> create(NextbillionMapController controller,
      {RouteLineProperties routeLineProperties =
          const RouteLineProperties()}) async {
    MapController mapController = NextbillionMapControllerWrapper(controller);
    var navMap = NavNextBillionMap._create(mapController,
        routeLineProperties: routeLineProperties);
    navMap.assetManager = AssetManager();
    await navMap.initGeoJsonSource();
    return navMap;
  }

  @visibleForTesting
  static Future<NavNextBillionMap> createWithAssetManager(
      MapController mapController, IAssetManager assetManager,
      {RouteLineProperties routeLineProperties =
          const RouteLineProperties()}) async {
    var navMap = NavNextBillionMap._create(mapController,
        routeLineProperties: routeLineProperties);
    navMap.assetManager = assetManager;
    await navMap.initGeoJsonSource();
    return navMap;
  }

  @override
  Future<void> initGeoJsonSource() async {
    if (controller.disposed) {
      return;
    }
    await _removePreviousSource();
    await _prepareSources();
    await _loadAssetImage();
    await initRouteLayers();
    _addListeners();
  }

  Future<void> _removePreviousSource() async {
    if (controller.disposed) {
      return;
    }
    await safeRemoveLayer(routeShieldLayerId);
    await safeRemoveLayer(routeLayerId);
    await safeRemoveLayer(waypointLayerId);
    await safeRemoveLayer(routeDurationLayerId);

    await safeRemoveSource(routeShieldSourceId);
    await safeRemoveSource(routeSourceId);
    await safeRemoveSource(waypointSourceId);
    await safeRemoveSource(routeDurationSourceId);
  }

  Future<void> _prepareSources() async {
    if (controller.disposed) {
      return;
    }

    await safeAddGeoJsonSource(routeShieldSourceId, buildFeatureCollection([]));
    await safeAddGeoJsonSource(routeSourceId, buildFeatureCollection([]));
    await safeAddGeoJsonSource(waypointSourceId, buildFeatureCollection([]));
    await safeAddGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection([]));
  }

  Future<void> _loadAssetImage() async {
    if (controller.disposed) {
      return;
    }
    var origin = await assetManager.load(routeLineProperties.originMarkerName);
    if (controller.disposed) {
      return;
    }
    var destination =
        await assetManager.load(routeLineProperties.destinationMarkerName);
    if (controller.disposed) {
      return;
    }
    await controller.addImage(originMarkerName, origin);
    if (controller.disposed) {
      return;
    }
    await controller.addImage(destinationMarkerName, destination);
  }

  /// add route shield layer, route layer, waypoint layer and route duration layer
  @override
  Future<void> initRouteLayers() async {
    if (controller.disposed) {
      return;
    }
    String? belowLayer = await controller.findBelowLayerId(
        [nbmapLocationId, highwayShieldLayerId, nbmapAnnotationId]);

    LineLayerProperties routeShieldLayer =
        routeLayerProvider.initializeRouteShieldLayer(
      routeLineProperties.routeScale,
      routeLineProperties.alternativeRouteScale,
      routeLineProperties.routeShieldColor,
      routeLineProperties.alternativeRouteShieldColor,
    );

    if (controller.disposed) {
      return;
    }
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

    if (controller.disposed) {
      return;
    }
    await controller.addLineLayer(routeSourceId, routeLayerId, routeLayer,
        belowLayerId: belowLayer);

    routeLayers[routeLayerId] = routeLayer;

    SymbolLayerProperties wayPointLayer = routeLayerProvider
        .initializeWayPointLayer(originMarkerName, destinationMarkerName);
    if (controller.disposed) {
      return;
    }
    await controller.addSymbolLayer(
        waypointSourceId, waypointLayerId, wayPointLayer);

    SymbolLayerProperties durationSymbolLayer =
        routeLayerProvider.initializeDurationSymbolLayer();

    if (controller.disposed) {
      return;
    }
    await controller.addSymbolLayer(
        routeDurationSourceId, routeDurationLayerId, durationSymbolLayer,
        belowLayerId: nbmapWaynameLayer);

    routeLayers[routeDurationLayerId] = durationSymbolLayer;
  }

  /// Draws the route on the map based on the provided [routes].
  /// it clears the previous route before drawing the new one.
  /// and then draws the route line, waypoints, and route duration symbol.
  @override
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

  /// Draws the route on the map based on the provided [routes].
  /// it clears the previous route before drawing the new one.
  /// and then draws the route line, waypoints, and route duration symbol.
  /// This method is used when there are multiple origin and destination routes.
  @override
  Future<void> drawIndependentRoutes(List<DirectionsRoute> routes) async {
    if (controller.disposed) {
      return;
    }

    if (routes.isEmpty) {
      return;
    }

    await clearRoute();
    await _drawRoutesFeatureCollections(routes);
    await _drawWayPointsWithRoutes(routes);
    await _drawRouteDurationSymbol(routes);
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
    await safeSetGeoJsonSource(
        routeShieldSourceId, buildFeatureCollection(reversed));
    await safeSetGeoJsonSource(routeSourceId, buildFeatureCollection(reversed));
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
          if (controller.disposed) {
            return;
          }
          await _buildWaypointNumberView(waypointName, i + 1);
        }
      }
    }

    var desGeo = _generateWaypointSymbolGeo(destination, destinationMarkerName);
    wayPoints.add(desGeo);

    await safeSetGeoJsonSource(
        waypointSourceId, buildFeatureCollection(wayPoints));
  }

  Future<void> _drawWayPointsWithRoutes(List<DirectionsRoute> routes) async {
    if (controller.disposed) {
      return;
    }

    List<Map<String, dynamic>> wayPoints = [];
    DirectionsRoute primaryRoute = routes.first;
    Coordinate origin = primaryRoute.legs.first.steps!.first.maneuver!.coordinate!;
    Coordinate destination = primaryRoute.legs.last.steps!.last.maneuver!.coordinate!;

    _addWaypoint(wayPoints, origin, originMarkerName);
    _addIntermediaryWaypoints(wayPoints, primaryRoute);
    _addWaypoint(wayPoints, destination, destinationMarkerName);

    for (var route in routes) {
      Coordinate? startCoordinate = route.legs.first.steps?.first.maneuver?.coordinate;
      Coordinate? endCoordinate = route.legs.last.steps?.last.maneuver?.coordinate;

      if (!_coordinatesEqual(startCoordinate, origin)) {
        _addWaypoint(wayPoints, startCoordinate, originMarkerName);
      }

      if (!_coordinatesEqual(endCoordinate, destination)) {
        _addWaypoint(wayPoints, endCoordinate, destinationMarkerName);
      }
    }

    await safeSetGeoJsonSource(waypointSourceId, buildFeatureCollection(wayPoints));
  }

  void _addWaypoint(List<Map<String, dynamic>> wayPoints, Coordinate? coordinate, String markerName) {
    if (coordinate != null) {
      var waypointGeo = _generateWaypointSymbolGeo(coordinate, markerName);
      wayPoints.add(waypointGeo);
    }
  }

  void _addIntermediaryWaypoints(List<Map<String, dynamic>> wayPoints, DirectionsRoute route) async {
    for (int i = 0; i < route.legs.length - 1; i++) {
      Leg leg = route.legs[i];
      Coordinate? destination = leg.steps?.last.maneuver?.coordinate;
      if (destination != null) {
        String waypointName = "$destinationMarkerName${i + 1}";
        _addWaypoint(wayPoints, destination, waypointName);
        if (controller.disposed) {
          return;
        }
        await _buildWaypointNumberView(waypointName, i + 1);
      }
    }
  }

  bool _coordinatesEqual(Coordinate? coord1, Coordinate? coord2) {
    if (coord1 == null || coord2 == null) {
      return false;
    }
    return coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude;
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
    if (controller.disposed) {
      return;
    }
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
      if (controller.disposed) {
        return;
      }
      await _setRouteDurationSymbol(durationSymbolKey, i, route);
    }
    await safeSetGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection(durationSymbols));
  }

  Future<void> _setRouteDurationSymbol(
      String durationSymbolKey, int index, DirectionsRoute route) async {
    if (controller.disposed) {
      return;
    }
    var image =
        await NBNavigation.captureRouteDurationSymbol(route, index == 0);

    if (controller.disposed) {
      return;
    }
    if (image != null) {
      await controller.addImage(durationSymbolKey, image);
    }
  }

  /// Adds a listener for route selection.
  /// The [clickedPoint] represents the point clicked on the map.
  /// The [onRouteSelectedCallback] will be invoked when a route is selected.
  @override
  void addRouteSelectedListener(
      LatLng clickedPoint, OnRouteSelectedCallback onRouteSelectedCallback) {
    if (routeLines.length < 2) {
      return;
    }
    this.onRouteSelectedCallback = onRouteSelectedCallback;
    _findRouteSelectedIndex(clickedPoint);
  }

  /// Toggles the visibility of alternative routes on the map.
  /// The [alternativeVisible] parameter determines whether alternative routes should be visible or not.
  @override
  Future<void> toggleAlternativeVisibilityWith(bool alternativeVisible) async {
    if (controller.disposed) {
      return;
    }

    for (var entry in routeLayers.entries) {
      if (entry.key == routeShieldLayerId ||
          entry.key == routeLayerId ||
          entry.key == routeDurationLayerId) {
        if (alternativeVisible) {
          if (controller.disposed) {
            return;
          }
          Platform.isIOS
              ? await controller
                  .setFilter(entry.key, ['<=', primaryRoutePropertyKey, 'true'])
              : await controller.setFilter(entry.key, ['literal', true]);
        } else {
          if (controller.disposed) {
            return;
          }
          await controller
              .setFilter(entry.key, ['==', primaryRoutePropertyKey, 'true']);
        }
      }
    }
  }

  /// Toggles the visibility of the duration symbol on the map.
  /// The [durationSymbolVisible] parameter determines whether the duration symbol should be visible or not.
  @override
  void toggleDurationSymbolVisibilityWith(bool durationSymbolVisible) {
    if (controller.disposed) {
      return;
    }
    controller.setVisibility(routeDurationLayerId, durationSymbolVisible);
  }

  /// Clears the currently displayed route from the map.
  @override
  Future<void> clearRoute() async {
    await clearSources();
    routeLines.clear();
  }

  Future<void> clearSources() async {
    if (controller.disposed) {
      return;
    }
    await safeSetGeoJsonSource(routeShieldSourceId, buildFeatureCollection([]));
    await safeSetGeoJsonSource(routeSourceId, buildFeatureCollection([]));
    await safeSetGeoJsonSource(waypointSourceId, buildFeatureCollection([]));
    await safeSetGeoJsonSource(
        routeDurationSourceId, buildFeatureCollection([]));
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

  Future safeRemoveLayer(String layerId) async {
    if (!controller.disposed) {
      await controller.removeLayer(layerId);
    }
  }

  Future safeRemoveSource(String sourceId) async {
    if (!controller.disposed) {
      await controller.removeSource(sourceId);
    }
  }

  Future safeAddGeoJsonSource(
      String sourceId, Map<String, dynamic> geoJson) async {
    if (!controller.disposed) {
      await controller.addGeoJsonSource(sourceId, geoJson);
    }
  }

  Future safeSetGeoJsonSource(
      String sourceId, Map<String, dynamic> geoJson) async {
    if (!controller.disposed) {
      await controller.setGeoJsonSource(sourceId, geoJson);
    }
  }
}
