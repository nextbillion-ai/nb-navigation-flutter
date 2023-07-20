part of nb_navigation_flutter;

class DirectionsRoute {
  num? distance;
  num? duration;
  String? geometry;
  List<Leg> legs;
  String? routeIndex;
  RouteOptions? routeOptions;
  num? weight;
  String? countryCode;

  DirectionsRoute({
    this.distance,
    this.duration,
    this.geometry,
    required this.legs,
    this.routeIndex,
    this.routeOptions,
    this.weight,
    this.countryCode,
  });

  factory DirectionsRoute.fromJson(Map<String, dynamic> map) {
    return DirectionsRoute(
      distance: map['distance'] ?? 0.0,
      duration: map['duration'] ?? 0.0,
      geometry: map['geometry'] ?? '',
      legs: List<Leg>.from(map['legs']?.map((leg) => Leg.fromJson(leg)) ?? []),
      routeIndex: map['routeIndex'] ?? '',
      routeOptions: RouteOptions.fromJson(map['routeOptions'] ?? {}),
      weight: map['weight'],
      countryCode: map['countryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      'geometry': geometry,
      'legs': legs.map((x) => x.toJson()).toList(),
      'routeIndex': routeIndex,
      'routeOptions': routeOptions?.toJson(),
      'weight': weight,
      'countryCode': countryCode,
    };
  }
}

class Leg {
  Distance? distance;
  TimeDuration? duration;
  List<RouteStep>? steps;

  Leg({
    this.distance,
    this.duration,
    this.steps,
  });

  factory Leg.fromJson(Map<String, dynamic> map) {
    return Leg(
      distance: Distance.fromJson(map['distance'] ?? {}),
      duration: TimeDuration.fromJson(map['duration'] ?? {}),
      steps: List<RouteStep>.from(map['steps']?.map((step) => RouteStep.fromJson(step)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'steps': steps?.map((x) => x.toJson()).toList(),
    };
  }
}

class Distance {
  num? value;

  Distance({
    this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> map) {
    return Distance(
      value: map['value'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}

class TimeDuration {
  num? value;

  TimeDuration({
    this.value,
  });

  factory TimeDuration.fromJson(Map<String, dynamic> map) {
    return TimeDuration(
      value: map['value'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}
