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
    initRouteLayers();
    _addListeners();
  }

  void initGeoJsonSource() async {
    _removePreviousSource();
    controller.addGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection([]));
    controller.addGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection([]));
    await _loadAssetImage();
  }

  Future<void> initRouteLayers() async {
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
  Future<void> drawRoute(List<DirectionsRoute> routes) async {
    if (routes.isEmpty) {
      return;
    }
    clearRoute();
    await _drawRoutesFeatureCollections(routes);
    await _drawWayPoints(routes.first);
    await _drawRouteDurationSymbol(routes);
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

  Future<void> _drawRoutesFeatureCollections(List<DirectionsRoute> routes) async {
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
    await controller.setGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection(reversed));
    await controller.setGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection(reversed));
  }

  int _getDecodePrecision(RouteOptions? routeOptions) {
    return routeOptions?.geometryType == SupportedGeometry.polyline ? PRECISION : PRECISION_6;
  }

  Future<void> _drawWayPoints(DirectionsRoute route) async {
    List<Map<String, dynamic>> wayPoints = [];
    for (int i = 0; i < route.legs.length; i++) {
      Leg leg = route.legs[i];
      Coordinate? origin = leg.steps?.first.maneuver?.coordinate;
      Coordinate? destination = leg.steps?.last.maneuver?.coordinate;
      if (origin != null && destination != null) {
        SymbolOptions originSymbol = SymbolOptions(geometry: LatLng(origin.latitude, origin.longitude));
        SymbolOptions desSymbol = SymbolOptions(geometry: LatLng(destination.latitude, destination.longitude));
        Map<String, dynamic> originGeo = originSymbol.toGeoJson();
        originGeo['properties'][WAYPOINT_PROPERTY_KEY] = WAYPOINT_ORIGIN_VALUE;
        Map<String, dynamic> desGeo = desSymbol.toGeoJson();
        desGeo['properties'][WAYPOINT_PROPERTY_KEY] = WAYPOINT_DESTINATION_VALUE;
        wayPoints.add(originGeo);
        wayPoints.add(desGeo);
      }
    }
    await controller.setGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection(wayPoints));
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
    await controller.setGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection(durationSymbols));
  }

  Future<void> _setRouteDurationSymbol(String durationSymbolKey, int index, DirectionsRoute route) async {
    String duration = TimeFormatter.formatSeconds(route.duration!.toInt());
    Widget widgetToImageConverter = DurationSymbol(
      text: duration,
      isPrimary: index == 0,
      primaryBackgroundColor: routeLineProperties.durationSymbolPrimaryBackgroundColor,
      primaryTextStyle: routeLineProperties.durationSymbolPrimaryTextStyle,
      alternativeBackgroundColor: routeLineProperties.durationSymbolAlternativeBackgroundColor,
      alternativeTextStyle: routeLineProperties.durationSymbolAlternativeTextStyle,
    );
    var image = await CaptureImageUtil.createImageFromWidget(widgetToImageConverter, imageSize: const Size(100, 60));
    await controller.addImage(durationSymbolKey, image!);
  }

  /// Toggles the visibility of alternative routes on the map.
  /// The [alternativeVisible] parameter determines whether alternative routes should be visible or not.
  void toggleAlternativeVisibilityWith(bool alternativeVisible) {
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
    controller.setVisibility(ROUTE_DURATION_LAYER_ID, durationSymbolVisible);
  }

  Future<void> _loadAssetImage() async {
    var origin = await transferAssetImage(routeLineProperties.originMarkerName);
    var destination = await transferAssetImage(routeLineProperties.destinationMarkerName);
    controller.addImage(ORIGIN_MARKER_NAME, origin);
    controller.addImage(DESTINATION_MARKER_NAME, destination);
  }

  void _removePreviousSource() {
    controller.removeSource(ROUTE_SHIELD_SOURCE_ID);
    controller.removeSource(ROUTE_SOURCE_ID);
    controller.removeSource(WAYPOINT_SOURCE_ID);
    controller.removeSource(ROUTE_DURATION_SOURCE_ID);
  }

  /// Clears the currently displayed route from the map.
  void clearRoute() {
    controller.setGeoJsonSource(ROUTE_SHIELD_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(ROUTE_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(WAYPOINT_SOURCE_ID, buildFeatureCollection([]));
    controller.setGeoJsonSource(ROUTE_DURATION_SOURCE_ID, buildFeatureCollection([]));
    routeLines.clear();
  }

  void _addListeners() {
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
