part of nb_navigation_flutter;

/// Represents the request parameters for a route.
/// Refer to Navigation API https://docs.nextbillion.ai/docs/navigation/api/navigation
class RouteRequestParams {
  /// The origin point of route request.
  LatLng origin;

  /// The destination point of route request.
  LatLng destination;

  int? altCount;

  /// Whether to try to return alternative routes (true) or not (false, default). An alternative
  /// route is a route that is significantly different than the fastest route, but also still
  /// reasonably fast. Such a route does not exist in all circumstances. Up to two alternatives may
  /// be returned.
  /// The default is false.
  bool? alternatives;

  /// The route classes that the calculated routes will avoid.
  /// Possible values are:
  /// [SupportedAvoid.toll]
  /// [SupportedAvoid.ferry]
  /// [SupportedAvoid.highway]
  /// [SupportedAvoid.none]
  /// Please note that when this parameter is not provided in the input, [SupportedAvoid.ferry] are set to be avoided by default.
  /// When this parameter is provided, only the mentioned objects are avoided.
  List<SupportedAvoid>? avoid;

  ///The same base URL which was used during the request that resulted in this root directions
  String? baseUrl;
  int? departureTime;

  /// A valid Nbmap access token used to making the request.
  String? key;

  /// The language of returned turn-by-turn text instructions. The default is en (English).
  String? language;

  /// A string specifying the primary mode of transportation for the routes.
  /// This parameter, if set, should be set to
  /// [ValidModes.car], [ValidModes.truck]
  /// [ValidModes.car] is used by default.
  ValidModes? mode;

  /// Displays the requested type of overview geometry. Can be
  /// [ValidOverview.full], [ValidOverview.simplified], [ValidOverview.none].
  /// The default is [ValidOverview.full].
  ValidOverview? overview;

  bool? simulation;

  /// This parameter defines the weight of the truck including trailers and shipped goods in kilograms (kg).
  /// This parameter is effective only when the mode=[ValidModes.truck] and option = [SupportedOption.flexible]
  int? truckWeight;

  /// This defines the dimensions of a truck in centimeters (cm).
  /// This should be specified if the route involves a truck, and the size restrictions may affect the route calculation.
  /// The list contains the dimensions of the truck in the order [height, width, length].
  /// This parameter is effective only when the mode=[ValidModes.truck] and option = [SupportedOption.flexible]
  List<int>? truckSize;

  /// The unit of measurement of the route. Can be
  /// [SupportedUnits.imperial], [SupportedUnits.metric]
  /// The default is [SupportedUnits.metric].
  SupportedUnits? unit;

  /// A list of Points to visit in order.
  /// Note that these coordinates are different than the direction responses
  /// waypoints that these are the non-snapped coordinates.
  List<LatLng>? waypoints;

  ///Use this option to switch to truck-specific routing or time based routing
  ///or if you want to choose between the fastest and shortest route types
  SupportedOption? option;

  /// The format of the returned geometry. Allowed values are:
  /// [SupportedGeometry.polyline], [SupportedGeometry.polyline6]
  /// The default is [SupportedGeometry.polyline6].
  SupportedGeometry? geometry;

  RouteRequestParams({
    required this.origin,
    required this.destination,
    this.altCount,
    this.alternatives,
    this.avoid,
    this.baseUrl,
    this.departureTime,
    this.key,
    this.language,
    this.mode,
    this.overview,
    this.simulation,
    this.truckWeight,
    this.truckSize,
    this.unit,
    this.waypoints,
    this.option,
    this.geometry,
  });

  factory RouteRequestParams.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty) {
      return RouteRequestParams(
        origin: const LatLng(0, 0),
        destination: const LatLng(0, 0),
      );
    }
    return RouteRequestParams(
      altCount: map['altCount'],
      alternatives: map['alternatives'],
      avoid: List<SupportedAvoid>.from((map['avoid'] as List<dynamic>?)
              ?.map((x) => SupportedAvoid.fromValue(x)) ??
          []),
      baseUrl: map['baseUrl'],
      departureTime: map['departureTime'],
      destination: LatLng(map['destination'][1], map['destination'][0]),
      key: map['key'],
      language: map['language'],
      mode: ValidModes.fromValue(map['mode']),
      origin: LatLng(map['origin'][1], map['origin'][0]),
      overview: ValidOverview.fromValue(map['overview']),
      simulation: map['simulation'],
      truckWeight: map['truckWeight'],
      truckSize: (map['truckSize'] as List<dynamic>?)
          ?.map((item) => (item is String) ? int.parse(item) : (item as int))
          .toList(),
      unit: SupportedUnits.fromValue(map['unit']),
      option: SupportedOption.fromValue(map['option']),
      geometry: SupportedGeometry.fromValue(map["geometry"]),
      waypoints: List<LatLng>.from(
          map['waypoints']?.map((point) => LatLng(point[1], point[0])) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'altCount': altCount,
      'alternatives': alternatives,
      'avoid': avoid?.map((e) => e.description).toList(),
      'baseUrl': baseUrl,
      'departureTime': departureTime,
      'destination': destination.toGeoJsonCoordinates(),
      'key': key,
      'language': language,
      'mode': mode?.description,
      'origin': origin.toGeoJsonCoordinates(),
      'overview': overview?.description,
      'simulation': simulation,
      'truckWeight': truckWeight,
      'truckSize': truckSize,
      'unit': unit?.description,
      'option': option?.description,
      'geometry': geometry?.description,
      'waypoints': waypoints?.map((e) => e.toGeoJsonCoordinates()).toList(),
    };
  }
}
