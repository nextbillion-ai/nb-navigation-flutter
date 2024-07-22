part of nb_navigation_flutter;

typedef OnNavigationViewReadyCallBack = void Function(NavigationViewController controller);

class NBNavigationView extends StatefulWidget {
  const NBNavigationView({
    super.key,
    required this.navigationOptions,
    this.onNavigationViewReady,
    this.onProgressChange,
    this.onNavigationCancelling,
    this.onArriveAtWaypoint,
    this.onRerouteFromLocation,
    this.onRerouteAlongCallback,
    this.onRerouteFailureCallback,
  });

  final NavigationLauncherConfig? navigationOptions;

  final OnNavigationViewReadyCallBack? onNavigationViewReady;
  final ProgressChangeCallback? onProgressChange;
  final OnNavigationCancellingCallback? onNavigationCancelling;
  final OnArriveAtWaypointCallback? onArriveAtWaypoint;
  final OnRerouteFromLocationCallback? onRerouteFromLocation;
  final OnRerouteAlongCallback? onRerouteAlongCallback;
  final OnRerouteFailureCallback? onRerouteFailureCallback;

  @override
  State<NBNavigationView> createState() => _NBNavigationViewState();
}

class _NBNavigationViewState extends State<NBNavigationView> {
  final Completer<NavigationViewController> _controller = Completer<NavigationViewController>();

  final NBNavigationViewPlatform _nbNavViewPlatform = NBNavigationViewPlatform.createInstance();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    if (widget.navigationOptions != null) {
      creationParams['launcherConfig'] = widget.navigationOptions!.toJson();
      if (Platform.isIOS) {
        creationParams["routeOptions"] = jsonEncode(widget.navigationOptions!.route.routeOptions);
      }
    }
    return _nbNavViewPlatform.buildView(creationParams, _onPlatformViewCreated);
  }

  void _onPlatformViewCreated(int id) async {
    await _nbNavViewPlatform.initPlatform(id);
    final NavigationViewController controller = NavigationViewController(
      navViewPlatform: _nbNavViewPlatform,
      onProgressChange: widget.onProgressChange,
      onNavigationCancelling: widget.onNavigationCancelling,
      arriveAtWaypointCallback: widget.onArriveAtWaypoint,
      onRerouteFromLocationCallback: widget.onRerouteFromLocation,
      onRerouteAlongCallback: widget.onRerouteAlongCallback,
      onRerouteFailureCallback: widget.onRerouteFailureCallback,
    );
    _controller.complete(controller);

    if (widget.onNavigationViewReady != null) {
      _nbNavViewPlatform.setOnNavigationRunningCallback(() {
        widget.onNavigationViewReady!(controller);
      });
    }
  }

  @override
  void dispose() async {
    super.dispose();
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.dispose();
    }
  }
}
