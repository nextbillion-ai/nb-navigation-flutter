part of nb_navigation_flutter;

class NavigationViewController {
  final NBNavigationViewPlatform _navViewPlatform;
  late StreamSubscription<NavigationProgress?>? _navProgressSubscription;
  late ProgressChangeCallback? onProgressChange;
  late OnNavigationCancellingCallback? onNavigationCancelling;
  late OnArriveAtWaypointCallback? arriveAtWaypointCallback;
  late OnRerouteFromLocationCallback? onRerouteFromLocationCallback;

  NavigationViewController({
    required NBNavigationViewPlatform navViewPlatform,
    this.onProgressChange,
    this.onNavigationCancelling,
    this.arriveAtWaypointCallback,
    this.onRerouteFromLocationCallback,
  }) : _navViewPlatform = navViewPlatform {
    _navProgressSubscription = _navViewPlatform.navProgressListener?.listen((navProgress) {
      if (onProgressChange != null) {
        onProgressChange!(navProgress);
      }
    });
    if (onNavigationCancelling != null) {
      _navViewPlatform.setOnNavigationCancellingCallback(onNavigationCancelling);
    }
    if (arriveAtWaypointCallback != null) {
      _navViewPlatform.setOnArriveAtWaypointCallback(arriveAtWaypointCallback);
    }
    if (arriveAtWaypointCallback != null) {
      _navViewPlatform.setOnArriveAtWaypointCallback(arriveAtWaypointCallback);
    }
    if (onRerouteFromLocationCallback != null) {
      _navViewPlatform.setOnRerouteFromLocationCallback(onRerouteFromLocationCallback);
    }
  }

  void dispose() {
    _navProgressSubscription?.cancel();
    _navViewPlatform.stopNavigation();
    _navViewPlatform.dispose();
  }
}
