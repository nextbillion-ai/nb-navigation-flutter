part of nb_navigation_flutter;

class RouteOptions {
  int? altCount;
  bool? alternatives;
  List<SupportedAvoid>? avoid;
  String? baseUrl;
  int? departureTime;
  String? key;
  String? language;
  ValidModes? mode;
  ValidOverview? overview;
  bool? simulation;
  int? truckWeight;
  SupportedUnits? unit;
  List<dynamic>? waypoints;
  SupportedOption? option;
  SupportedGeometry? geometryType;
  String? geometry;
  List<dynamic>? origin;
  List<dynamic>? destination;

  RouteOptions({
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
    this.unit,
    this.waypoints,
    this.option,
    this.geometryType,
    this.geometry,
    this.origin,
    this.destination,
  });

  factory RouteOptions.fromJson(Map<String, dynamic> map) {
    return RouteOptions(
      altCount: map['altCount'],
      alternatives: map['alternatives'],
      avoid: _decodeAvoid(map),
      baseUrl: map['baseUrl'],
      departureTime: map['departureTime'],
      key: map['key'],
      language: map['language'],
      mode: enumValue(map['mode']) as ValidModes?,
      overview: enumValue(map['overview']) as ValidOverview?,
      simulation: map['simulation'],
      truckWeight: map['truckWeight'],
      unit: enumValue(map['unit']) as SupportedUnits?,
      option: enumValue(map['option']) as SupportedOption?,
      geometryType: enumValue(map["geometryType"]) as SupportedGeometry?,
      geometry: map["geometry"],
      waypoints: _decodeWayPoints(map['waypoints']),
      origin: map["origin"] ?? [],
      destination: map["destination"] ?? [],
    );
  }

  static List<dynamic> _decodeWayPoints(List<dynamic>? waypoints) {
    if (waypoints != null && waypoints.isNotEmpty) {
      if (waypoints.first is List<dynamic>) {
        return waypoints;
      } else {
        return List<Coordinate>.from(waypoints.map((x) => Coordinate.fromJson(x)) ?? []);
      }
    }
    return [];
  }

  static List<SupportedAvoid> _decodeAvoid(Map<String, dynamic> map) {
    List<SupportedAvoid> avoids = [];
    if(map['avoid'] == null) {
      return avoids;
    }
    var listString = map['avoid'] as List<dynamic>;

    for (var element in listString) {
      if(enumValue(element) is SupportedAvoid) {
        avoids.add(enumValue(element) as SupportedAvoid);
      }
    }
    return avoids;
  }

  Map<String, dynamic> toJson() {
    return {
      'altCount': altCount,
      'alternatives': alternatives,
      'avoid': avoid?.map((e) => e.description).toList(),
      'baseUrl': baseUrl,
      'departureTime': departureTime,
      'key': key,
      'language': language,
      'mode': mode?.description,
      'overview': overview?.description,
      'simulation': simulation,
      'truckWeight': truckWeight,
      'unit': unit?.description,
      'option': option?.description,
      'geometry': geometry,
      'geometryType': geometryType?.description,
      'waypoints': _encodeWayPoints(waypoints),
      "origin": origin,
      "destination": destination,
    };
  }

  static List<dynamic> _encodeWayPoints(List<dynamic>? waypoints) {
    if (waypoints != null && waypoints.isNotEmpty) {
      if (waypoints.first is List<dynamic>) {
        return waypoints;
      } else {
        return waypoints.map((e) => e.toJson()).toList() ?? [];
      }
    }
    return [];
  }
}
