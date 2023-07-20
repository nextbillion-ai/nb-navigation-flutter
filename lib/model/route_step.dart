part of nb_navigation_flutter;

class RouteStep {
  List<BannerInstructions>? bannerInstructions;
  String? drivingSide;
  String? geometry;
  List<Intersection>? intersections;
  Maneuver? maneuver;
  String? name;
  Distance? distance;
  TimeDuration? duration;
  Map<String, dynamic>? roadShield;
  List<VoiceInstruction>? voiceInstructions;

  RouteStep({
    this.bannerInstructions,
    this.drivingSide,
    this.geometry,
    this.intersections,
    this.maneuver,
    this.name,
    this.distance,
    this.duration,
    this.roadShield,
    this.voiceInstructions,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
        bannerInstructions:
            List<BannerInstructions>.from(json['bannerInstructions']?.map((e) => BannerInstructions.fromJson(e)) ?? []),
        drivingSide: json['driving_side'] ?? '',
        geometry: json['geometry'] ?? '',
        intersections: List<Intersection>.from(
            json['intersections']?.map((intersection) => Intersection.fromJson(intersection)) ?? []),
        maneuver: Maneuver.fromJson(json['maneuver'] ?? {}),
        name: json['name'] ?? '',
        distance: Distance.fromJson(json['distance'] ?? {}),
        duration: TimeDuration.fromJson(json['duration'] ?? {}),
        roadShield: json['road_shield_type'] ?? {},
        voiceInstructions:
            List<VoiceInstruction>.from(json['voiceInstructions']?.map((vi) => VoiceInstruction.fromJson(vi)) ?? []));
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerInstructions': bannerInstructions?.map((vi) => vi.toJson()).toList(),
      'driving_side': drivingSide,
      'geometry': geometry,
      'intersections': intersections?.map((intersection) => intersection.toJson()).toList(),
      'maneuver': maneuver?.toJson(),
      'name': name,
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'road_shield_type': roadShield,
      'voiceInstructions': voiceInstructions?.map((vi) => vi.toJson()).toList(),
    };
  }
}
