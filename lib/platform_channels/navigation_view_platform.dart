// ignore_for_file: unnecessary_getters_setters

part of nb_navigation_flutter;

typedef ProgressChangeCallback = void Function(NavigationProgress? progress);
typedef OnNavigationCancellingCallback = void Function();
typedef OnNavigationRunningCallback = void Function();
typedef OnArriveAtWaypointCallback = void Function(Waypoint? atWaypoint);
typedef OnRerouteFromLocationCallback = void Function(LatLng? rereouteFromLocation);

abstract class NBNavigationViewPlatform {

  static NBNavigationViewPlatform Function() createInstance =
      () => MethodChannelNavigationView();

  OnNavigationCancellingCallback? _onNavigationCancellingCallback;
  OnNavigationRunningCallback? _onNavigationRunningCallback;
  OnArriveAtWaypointCallback? _arriveAtWaypointCallback;
  OnRerouteFromLocationCallback? _rerouteFromLocationCallback;

  Future<void> initPlatform(int id);
  Widget buildView(
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated);

  void setOnNavigationCancellingCallback(OnNavigationCancellingCallback? callback);
  void setOnNavigationRunningCallback(OnNavigationRunningCallback? callback);
  void setOnArriveAtWaypointCallback(OnArriveAtWaypointCallback? callback);
  void setOnRerouteFromLocationCallback(OnRerouteFromLocationCallback? callback);
  Stream<NavigationProgress?>? get navProgressListener;
  Future<void> stopNavigation();
  void dispose();

}
