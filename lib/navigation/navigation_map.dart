import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

abstract class NavigationMap {
  Future<void> initGeoJsonSource();
  Future<void> initRouteLayers();
  Future<void> drawRoute(List<DirectionsRoute> routes);
  Future<void> clearRoute();
  void toggleDurationSymbolVisibilityWith(bool durationSymbolVisible);
  Future<void> toggleAlternativeVisibilityWith(bool alternativeVisible);
  void addRouteSelectedListener(
      LatLng clickedPoint, OnRouteSelectedCallback onRouteSelectedCallback);
}
