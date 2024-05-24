part of nb_navigation_flutter;

enum LocationLayerRenderMode {
  normal,
  compass,
  gps,
}

enum NavigationThemeMode {
  system,
  light,
  dark,
}

class NavigationLauncherConfig {
  /// The selected route for navigation.
  DirectionsRoute route;

  /// All routes return from route request contains alternative routes.
  List<DirectionsRoute>? routes;

  /// The theme mode for the navigation View. Can be
  /// [NavigationThemeMode.system], [NavigationThemeMode.light], [NavigationThemeMode.dark]
  /// The default is NavigationThemeMode.system.
  NavigationThemeMode? themeMode;

  /// The location layer render mode in the Navigation View. Can be
  /// [LocationLayerRenderMode.normal], [LocationLayerRenderMode.compass], [LocationLayerRenderMode.gps]
  /// Default is LocationLayerRenderMode.GPS.
  LocationLayerRenderMode? locationLayerRenderMode;

  /// Indicates whether to simulate the route during Navigation.
  /// Default is false.
  bool? shouldSimulateRoute;

  /// Indicates whether to show the dissolved route line.
  /// Default is true.
  bool? enableDissolvedRouteLine;

  /// Indicates whether to enable the custom style defined in
  /// styles.xml for Android (`CustomNavigationViewLight`, `CustomNavigationViewDark`)
  /// AppDelegate for iOS (`customDayStyle`, `customNightStyle`)
  bool? useCustomNavigationStyle;

  /// Indicates the map style in Navigation view.
  /// Its priority is higher than
  /// the navViewMapStyle of (`CustomNavigationViewLight`, `CustomNavigationViewDark`) set in the styles.xml for Android
  /// the mapStyleURL of (`customDayStyle`, `customNightStyle`) set in the AppDelegate for iOS
  String? navigationMapStyleUrl;
  // bool? showSpeedometer;
  // double? maxNavCameraTilt;
  // double? minNavCameraTilt;
  // double? maxNavCameraZoom;
  // double? minNavCameraZoom;

  NavigationLauncherConfig({
    required this.route,
    required this.routes,
    this.themeMode = NavigationThemeMode.system,
    this.locationLayerRenderMode = LocationLayerRenderMode.gps,
    this.shouldSimulateRoute,
    this.enableDissolvedRouteLine = true,
    this.useCustomNavigationStyle = true,
    this.navigationMapStyleUrl,
    // this.showSpeedometer = true,
    // this.maxNavCameraTilt,
    // this.minNavCameraTilt,
    // this.maxNavCameraZoom,
    // this.minNavCameraZoom,
  });

  Map<String, dynamic> toJson() {
    return {
      'route': jsonEncode(route),
      'routes': routes?.map((e) => jsonEncode(e)).toList(),
      'themeMode': themeMode?.description,
      'locationLayerRenderMode': locationLayerRenderMode?.index,
      'shouldSimulateRoute': shouldSimulateRoute,
      'enableDissolvedRouteLine': enableDissolvedRouteLine,
      'useCustomNavigationStyle': useCustomNavigationStyle,
      'navigationMapStyleUrl': navigationMapStyleUrl,
      // 'showSpeedometer': showSpeedometer,
      // 'maxNavCameraTilt': maxNavCameraTilt,
      // 'minNavCameraTilt': minNavCameraTilt,
      // 'maxNavCameraZoom': maxNavCameraZoom,
      // 'minNavCameraZoom': minNavCameraZoom,
    };
  }

}
