import 'package:flutter_test/flutter_test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

void main() {
  group('NavigationProgress', () {
    test('fromJson should return a valid NavigationProgress object', () {
      // Arrange
      final json = {
        'location': {
          'latitude': 12.34,
          'longitude': 56.78,
        },
        'distanceRemaining': 1000,
        'durationRemaining': 300,
      };

      // Act
      final navigationProgress = NavigationProgress.fromJson(json);

      // Assert
      expect(navigationProgress.location?.latitude, 12.34);
      expect(navigationProgress.location?.longitude, 56.78);
      expect(navigationProgress.distanceRemaining, 1000);
      expect(navigationProgress.durationRemaining, 300);
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      final navigationProgress = NavigationProgress(
        location: const LatLng(12.34, 56.78),
        distanceRemaining: 1000,
        durationRemaining: 300,
      );

      // Act
      final json = navigationProgress.toJson();

      // Assert
      expect(json['location']['latitude'], 12.34);
      expect(json['location']['longitude'], 56.78);
      expect(json['distanceRemaining'], 1000);
      expect(json['durationRemaining'], 300);
    });

    test('toString should return a valid string representation', () {
      // Arrange
      final navigationProgress = NavigationProgress(
        location: const LatLng(12.34, 56.78),
        distanceRemaining: 1000,
        durationRemaining: 300,
      );

      // Act
      final stringRepresentation = navigationProgress.toString();

      // Assert
      expect(
        stringRepresentation,
        'NavigationProgress(location: LatLng(12.34, 56.78), distanceRemaining: 1000, durationRemaining: 300)',
      );
    });
  });
}
