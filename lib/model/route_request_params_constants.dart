part of nb_navigation_flutter;

enum SupportedUnits {
  /// Imperial units (e.g., miles, feet).
  imperial,

  /// Metric units (e.g., kilometers, meters).
  metric
}

enum ValidModes {
  /// Travel mode: walking.
  foot,

  /// Travel mode: cycling/biking.
  bike,

  /// Travel mode: motorcycle.
  motorcycle,

  /// Travel mode: car.
  car,

  /// Travel mode: truck.
  truck
}

enum SupportedAvoid {
  /// Avoid tolls during the route.
  toll,

  /// Avoid ferries during the route.
  ferry,

  /// Avoid highways during the route.
  highway
}

enum ValidOverview {
  /// Show a full overview of the route with all details.
  full,

  /// Show a simplified overview of the route.
  simplified,

  /// Show no overview (only the route's geometry).
  none
}

enum SupportedGeometry {
  /// Use polyline format for route geometry.
  polyline,

  /// Use polyline6 format for route geometry.
  polyline6
}

enum SupportedOption { flexible }

extension EnumExtension on Enum {
  String get description {
    if (this == ValidOverview.none) {
      return "false";
    }
    return toString().split('.').last;
  }
}

Enum? enumValue(String? value) {
  switch (value) {
    case "imperial":
      return SupportedUnits.imperial;
    case "metric":
      return SupportedUnits.metric;
    case "foot":
      return ValidModes.foot;
    case "bike":
      return ValidModes.bike;
    case "motorcycle":
      return ValidModes.motorcycle;
    case "car":
      return ValidModes.car;
    case "truck":
      return ValidModes.truck;
    case "toll":
      return SupportedAvoid.toll;
    case "ferry":
      return SupportedAvoid.ferry;
    case "highway":
      return SupportedAvoid.highway;
    case "full":
      return ValidOverview.full;
    case "simplified":
      return ValidOverview.simplified;
    case "false":
      return ValidOverview.none;
    case "polyline":
      return SupportedGeometry.polyline;
    case "polyline6":
      return SupportedGeometry.polyline6;
    case "flexible":
      return SupportedOption.flexible;
  }
  return null;
}
