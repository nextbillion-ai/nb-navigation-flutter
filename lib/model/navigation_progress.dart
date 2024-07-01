part of nb_navigation_flutter;

class NavigationProgress {
  LatLng? location;
  num? distanceRemaining;
  num? durationRemaining;

  NavigationProgress({
    this.location,
    this.distanceRemaining,
    this.durationRemaining,
  });

  factory NavigationProgress.fromJson(Map<String, dynamic> json) {
    return NavigationProgress(
      location: json['location'] != null
          ? LatLng(
              json['location']["latitude"],
              json['location']["longitude"],
            )
          : null,
      distanceRemaining: json['distanceRemaining'],
      durationRemaining: json['durationRemaining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': {"latitude": location?.latitude, "longitude": location?.longitude},
      'distanceRemaining': distanceRemaining,
      'durationRemaining': durationRemaining,
    };
  }

  @override
  String toString() {
    return 'NavigationProgress(location: $location, distanceRemaining: $distanceRemaining, durationRemaining: $durationRemaining)';
  }
}
