part of nb_navigation_flutter;

enum SupportedUnits {
  /// Imperial units (e.g., miles, feet).
  imperial,

  /// Metric units (e.g., kilometers, meters).
  metric;

  static SupportedUnits fromValue(String? s) => switch (s) {
    "imperial" => imperial,
    "metric" => metric,
    _ => metric
  };
}

enum ValidModes {
  /// Travel mode: car.
  car,

  /// Travel mode: truck.
  truck;

  static ValidModes fromValue(String? s) => switch (s) {
    "car" => car,
    "truck" => truck,
    _ => car
  };
}

enum SupportedAvoid {
  /// Avoid tolls during the route.
  toll,

  /// Avoid ferries during the route.
  ferry,

  /// Avoid highways during the route.
  highway,

  /// Avoid noting during the route.
  none;

  static SupportedAvoid fromValue(String? s) => switch (s) {
    "toll" => toll,
    "ferry" => ferry,
    "highway" => highway,
    "none" => none,
    _ => ferry
  };
}

enum ValidOverview {
  /// Show a full overview of the route with all details.
  full,

  /// Show a simplified overview of the route.
  simplified,

  /// Show no overview (only the route's geometry).
  none;

  static ValidOverview fromValue(String? s) => switch (s) {
    "full" => full,
    "simplified" => simplified,
    "false" => none,
    _ => full
  };
}

enum SupportedGeometry {
  /// Use polyline format for route geometry.
  polyline,

  /// Use polyline6 format for route geometry.
  polyline6;

  static SupportedGeometry fromValue(String? s) => switch (s) {
    "polyline" => polyline,
    "polyline6" => polyline6,
    _ => polyline6
  };
}

enum SupportedOption {
  flexible;

  static SupportedOption? fromValue(String? s) => switch (s) {
    "flexible" => flexible,
    _ => null,
  };
}

enum SupportedHazmatType {
  general,
  circumstantial,
  explosive,
  harmfulToWater;

  static SupportedHazmatType? fromValue(String? s) => switch (s) {
    "general" => general,
    "circumstantial" => circumstantial,
    "explosive" => general,
    "harmful_to_water" => harmfulToWater,
    _ => null,
  };
}


enum SupportedApproaches {
  curb,
  unrestricted;

  static SupportedApproaches? fromValue(String? s) => switch (s) {
    "curb" => curb,
    "unrestricted" => unrestricted,
    _ => null,
  };
}

extension EnumExtension on Enum {
  String get description {
    if (this == ValidOverview.none) {
      return "false";
    }
    if (this == SupportedHazmatType.harmfulToWater) {
      return "harmful_to_water";
    }
    return toString().split('.').last;
  }
}
