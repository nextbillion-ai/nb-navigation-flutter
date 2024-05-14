part of nb_navigation_flutter;

typedef OnRouteSelectedCallback = void Function(int selectedRouteIndex);

class NavNextBillionMap {
  NextbillionMapController controller;
  MapRouteLayerProvider routeLayerProvider = MapRouteLayerProvider();
  Map<String, LayerProperties> routeLayers = {};
  RouteLineProperties routeLineProperties;
  List<List<LatLng>> routeLines = [];
  OnRouteSelectedCallback? onRouteSelectedCallback;

  NavNextBillionMap(this.controller, {this.routeLineProperties = const RouteLineProperties()}) {
    initGeoJsonSource();
  }

  void initGeoJsonSource() {
    if (controller.disposed) {
      return;
    }
    _removePreviousSource();
    _addSource();
    _loadAssetImage();
    initRouteLayers();
    _addListeners();
  }

  Future<void> initRouteLayers() async {
    if (controller.disposed) {
      return;
    }
    String belowLayer = await controller.findBelowLayerId([NBMAP_LOCATION_ID, HIGHWAY_SHIELD_LAYER_ID, NBMAP_ANNOTATION_ID]);
    LineLayerProperties routeShieldLayer = routeLayerProvider.initializeRouteShieldLayer(
      routeLineProperties.routeScale,
      routeLineProperties.alternativeRouteScale,
      routeLineProperties.routeShieldColor,
      routeLineProperties.alternativeRouteShieldColor,
    );
    controller.addLineLayer(ROUTE_SHIELD_SOURCE_ID, ROUTE_SHIELD_LAYER_ID, routeShieldLayer, belowLayerId: belowLayer);
    routeLayers[ROUTE_SHIELD_LAYER_ID] = routeShieldLayer;

    LineLayerProperties routeLayer = routeLayerProvider.initializeRouteLayer(
      routeLineProperties.routeScale,
      routeLineProperties.alternativeRouteScale,
      routeLineProperties.routeDefaultColor,
      routeLineProperties.alternativeRouteDefaultColor,
    );
    controller.addLineLayer(ROUTE_SOURCE_ID, ROUTE_LAYER_ID, routeLayer, belowLayerId: belowLayer);
    routeLayers[ROUTE_LAYER_ID] = routeLayer;

    SymbolLayerProperties wayPointLayer =
    routeLayerProvider.initializeWayPointLayer(ORIGIN_MARKER_NAME, DESTINATION_MARKER_NAME);
    controller.addSymbolLayer(WAYPOINT_SOURCE_ID, WAYPOINT_LAYER_ID, wayPointLayer);

    SymbolLayerProperties durationSymbolLayer = routeLayerProvider.initializeDurationSymbolLayer();
    controller.addSymbolLayer(ROUTE_DURATION_SOURCE_ID, ROUTE_DURATION_LAYER_ID, durationSymbolLayer, belowLayerId: NBMAP_WAYNAME_LAYER);
    routeLayers[ROUTE_DURATION_LAYER_ID] = durationSymbolLayer;
  }

  /// Draws the route on the map based on the provided [routes].
  void drawRoute(List<DirectionsRoute> routes)  {
    if (controller.disposed) {
      return;
    }

    if (routes.isEmpty) {
      return;
    }
    clearRoute();
    _drawRoutesFeatureCollections(routes);
    _drawWayPoints(routes.first);
    _drawRouteDurationSymbol(routes);
  }

  /// Adds a listener for route selection.
  /// The [clickedPoint] represents the point clicked on the map.
  /// The [onRouteSelectedCallback] will be invoked when a route is selected.
  void addRouteSelectedListener(LatLng clickedPoint, OnRouteSelectedCallback onRouteSelectedCallback) {
    if (routeLines.length < 2) {
      return;
    }
    this.onRouteSelectedCallback = onRouteSelectedCallback;
    _findRouteSelectedIndex(clickedPoint);
  }

  void _drawRoutesFeatureCollections(List<DirectionsRoute> routes) {
    List<Map<String, dynamic>> routeLineFeatures = [];

    for (int i = 0; i < routes.length; i++) {
      DirectionsRoute route = routes[i];
      bool isPrimary = i == 0;

      List<LatLng> line = decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
      routeLines.add(line);
      LineOptions lineOptions = LineOptions(geometry: line);
      Map<String, dynamic> geoJson = Line("routeLine", lineOptions).toGeoJson();
      geoJson["properties"][PRIMARY_ROUTE_PROPERTY_KEY] = isPrimary ? "true" : "false";
      routeLineFeatures.add(geoJson);
    }
    if (routeLineFeatures.isEmpty) {
      return;
    }
    List<Map<String, dynamic>> reversed = routeLineFeatures.reversed.toList();
    controller.setGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection(reversed));
    controller.setGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection(reversed));
  }

  int _getDecodePrecision(RouteRequestParams? routeOptions) {
    return routeOptions?.geometry == SupportedGeometry.polyline ? PRECISION : PRECISION_6;
  }

  Future<void> _drawWayPoints(DirectionsRoute route) async {
    List<Map<String, dynamic>> wayPoints = [];
    Coordinate origin = route.legs.first.steps!.first.maneuver!.coordinate!;
    Coordinate destination =  route.legs.last.steps!.last.maneuver!.coordinate!;
    var originGeo = _generateWaypointSymbolGeo(origin, ORIGIN_MARKER_NAME);
    wayPoints.add(originGeo);
    if (route.legs.length > 1) {
      for (int i = 0; i < route.legs.length - 1; i++) {
        Leg leg = route.legs[i];
        Coordinate? destination = leg.steps?.last.maneuver?.coordinate;
        if (destination != null) {
          String waypointName = "$DESTINATION_MARKER_NAME${i+1}";
          var wayPointGeo = _generateWaypointSymbolGeo(destination, waypointName);
          wayPoints.add(wayPointGeo);
          _buildWaypointNumberView(waypointName, i+1);
        }
      }
    }
    var desGeo = _generateWaypointSymbolGeo(destination, DESTINATION_MARKER_NAME);
    wayPoints.add(desGeo);

    controller.setGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection(wayPoints));
  }

  Map<String, dynamic> _generateWaypointSymbolGeo(Coordinate coordinate, String propertiesValue) {
    SymbolOptions coordinateSymbol = SymbolOptions(geometry: LatLng(coordinate.latitude, coordinate.longitude));
    Map<String, dynamic> coordinateGeo = coordinateSymbol.toGeoJson();
    coordinateGeo['properties'][WAYPOINT_PROPERTY_KEY] = propertiesValue;
    return coordinateGeo;
  }

  _buildWaypointNumberView(String waypointName, int index) async {
    Widget numberView = WaypointNumberView(index);
    var image = await CaptureImageUtil.createImageFromWidget(numberView, imageSize: const Size(14, 14));
    controller.addImage(waypointName, image!);
  }

  Future<void> _drawRouteDurationSymbol(List<DirectionsRoute> routes) async {
    List<Map<String, dynamic>> durationSymbols = [];
    for (int i = 0; i < routes.length; i++) {
      DirectionsRoute route = routes[i];
      bool isPrimary = i == 0;
      List<LatLng> line = decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
      LatLng centerPoint = line[line.length ~/ 2];
      SymbolOptions durationSymbol = SymbolOptions(geometry: LatLng(centerPoint.latitude, centerPoint.longitude));
      Map<String, dynamic> geoJson = durationSymbol.toGeoJson();
      geoJson["properties"][PRIMARY_ROUTE_PROPERTY_KEY] = isPrimary ? "true" : "false";
      String durationSymbolKey = "ROUTE_DURATION_SYMBOL_ICON_KEY$i";
      geoJson["properties"][ROUTE_DURATION_SYMBOL_ICON_KEY] = durationSymbolKey;
      durationSymbols.add(geoJson);
      await _setRouteDurationSymbol(durationSymbolKey, i, route);
    }
    controller.setGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection(durationSymbols));
  }

  Future<void> _setRouteDurationSymbol(String durationSymbolKey, int index, DirectionsRoute route) async {
    String duration = await NBNavigation.getFormattedDuration(route.duration!.toDouble());
    Widget widgetToImageConverter = DurationSymbol(
      text: duration.toString().trimRight(),
      isPrimary: index == 0,
      primaryBackgroundColor: routeLineProperties.durationSymbolPrimaryBackgroundColor,
      primaryTextStyle: routeLineProperties.durationSymbolPrimaryTextStyle,
      alternativeBackgroundColor: routeLineProperties.durationSymbolAlternativeBackgroundColor,
      alternativeTextStyle: routeLineProperties.durationSymbolAlternativeTextStyle,
    );
    var image = await CaptureImageUtil.createImageFromWidget(widgetToImageConverter, imageSize: const Size(100, 60));
    controller.addImage(durationSymbolKey, image!);
  }

  /// Toggles the visibility of alternative routes on the map.
  /// The [alternativeVisible] parameter determines whether alternative routes should be visible or not.
  void toggleAlternativeVisibilityWith(bool alternativeVisible) {
    if (controller.disposed) {
      return;
    }
    routeLayers.forEach((key, value) {
      if (key == ROUTE_SHIELD_LAYER_ID || key == ROUTE_LAYER_ID || key == ROUTE_DURATION_LAYER_ID) {
        if (alternativeVisible) {
          Platform.isIOS ? controller.setFilter(key, ['<=', PRIMARY_ROUTE_PROPERTY_KEY, 'true'])
              : controller.setFilter(key, ['literal', true]);
        } else {
          controller.setFilter(key, ['==', PRIMARY_ROUTE_PROPERTY_KEY, 'true']);
        }
      }
    });
  }

  /// Toggles the visibility of the duration symbol on the map.
  /// The [durationSymbolVisible] parameter determines whether the duration symbol should be visible or not.
  void toggleDurationSymbolVisibilityWith(bool durationSymbolVisible) {
    if (controller.disposed) {
      return;
    }
    controller.setVisibility(ROUTE_DURATION_LAYER_ID, durationSymbolVisible);
  }

  Future<void> _loadAssetImage() async {
    if (controller.disposed) {
      return;
    }
    var origin = await transferAssetImage(routeLineProperties.originMarkerName);
    var destination = await transferAssetImage(routeLineProperties.destinationMarkerName);
    controller.addImage(ORIGIN_MARKER_NAME, origin);
    controller.addImage(DESTINATION_MARKER_NAME, destination);
  }

  Future<void> _addSource() async {
    if (controller.disposed) {
      return;
    }

    controller.addGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection([]));
  }

  void _removePreviousSource() {
    if (controller.disposed) {
      return;
    }

    controller.removeLayer(ROUTE_SHIELD_LAYER_ID);
    controller.removeLayer(ROUTE_LAYER_ID);
    controller.removeLayer(WAYPOINT_LAYER_ID);
    controller.removeLayer(ROUTE_DURATION_LAYER_ID);


    controller.removeSource(ROUTE_SHIELD_SOURCE_ID);
    controller.removeSource(ROUTE_SOURCE_ID);
    controller.removeSource(WAYPOINT_SOURCE_ID);
    controller.removeSource(ROUTE_DURATION_SOURCE_ID);
  }

  /// Clears the currently displayed route from the map.
  void clearRoute() {
    if (controller.disposed) {
      return;
    }
    controller.setGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection([]));
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
    NBNavigationPlatform.instance.findSelectedRouteIndex(clickedPoint, routeLines).then((routeIndex) {
      if(onRouteSelectedCallback != null) {
        onRouteSelectedCallback!(routeIndex);
      }
    });
  }

}
