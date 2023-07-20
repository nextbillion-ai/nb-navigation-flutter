part of nb_navigation_flutter;

class MapRouteLayerProvider {
  LineLayerProperties initializeRouteShieldLayer(
      double routeScale, double alternativeRouteScale, Color routeShieldColor, Color alternativeRouteShieldColor) {
    return LineLayerProperties(
      lineCap: "round",
      lineJoin: "round",
      lineWidth: [
        Expressions.interpolate,
        ['exponential', 1.5],
        [Expressions.zoom],
        10,
        7,
        14,
        list(10.5, routeScale, alternativeRouteScale),
        16.6,
        list(15.5, routeScale, alternativeRouteScale),
        19,
        list(24, routeScale, alternativeRouteScale),
        22,
        list(29, routeScale, alternativeRouteScale),
      ],
      lineColor: [
        Expressions.match,
        [Expressions.get, PRIMARY_ROUTE_PROPERTY_KEY],
        "true",
        routeShieldColor.toHexStringRGB(),
        alternativeRouteShieldColor.toHexStringRGB(),
      ],
    );
  }

  LineLayerProperties initializeRouteLayer(
      double routeScale, double alternativeRouteScale, Color routeDefaultColor, Color alternativeRouteDefaultColor) {
    return LineLayerProperties(
      lineCap: "round",
      lineJoin: "round",
      lineWidth: [
        Expressions.interpolate,
        ['exponential', 1.5],
        [Expressions.zoom],
        4,
        list(3, routeScale, alternativeRouteScale),
        10,
        list(4, routeScale, alternativeRouteScale),
        13,
        list(6, routeScale, alternativeRouteScale),
        16,
        list(10, routeScale, alternativeRouteScale),
        19,
        list(14, routeScale, alternativeRouteScale),
        22,
        list(18, routeScale, alternativeRouteScale),
      ],
      lineColor: [
        Expressions.match,
        [Expressions.get, PRIMARY_ROUTE_PROPERTY_KEY],
        "true",
        routeDefaultColor.toHexStringRGB(),
        alternativeRouteDefaultColor.toHexStringRGB(),
      ],
    );
  }

  SymbolLayerProperties initializeWayPointLayer(String originMarkerName, String destinationMarkerName) {
    return SymbolLayerProperties(iconImage: [
      Expressions.match,
      [Expressions.get, WAYPOINT_PROPERTY_KEY],
      WAYPOINT_ORIGIN_VALUE,
      originMarkerName,
      destinationMarkerName
    ], iconSize: [
      Expressions.interpolate,
      ['exponential', 1.5],
      [Expressions.zoom],
      0,
      0.6,
      10,
      0.8,
      12,
      1.3,
      22,
      2.8,
    ], iconPitchAlignment: 'map', iconAllowOverlap: true, iconIgnorePlacement: true);
  }


  SymbolLayerProperties initializeDurationSymbolLayer() {
    return const SymbolLayerProperties(
        iconImage: [Expressions.get, ROUTE_DURATION_SYMBOL_ICON_KEY],
        iconSize: [
          Expressions.interpolate,
          ['exponential', 1.5],
          [Expressions.zoom],
          0,
          0.8,
          10,
          1.0,
          12,
          1.2,
          22,
          1.3,
        ],
        iconAllowOverlap: true,
        symbolPlacement: 'point',
        iconRotationAlignment: 'viewport',
        iconTranslateAnchor: 'viewport',
        iconAnchor: [ Expressions.match,
          [Expressions.get, PRIMARY_ROUTE_PROPERTY_KEY],
          "true",
          'top-left',
          'top-right']
    );
  }

  List<Object> list(double base, double routeScale, double alternativeRouteScale) {
    return [
      Expressions.multiply,
      base,
      [
        Expressions.match,
        [Expressions.get, PRIMARY_ROUTE_PROPERTY_KEY],
        'true',
        routeScale,
        alternativeRouteScale
      ],
    ];
  }
}
