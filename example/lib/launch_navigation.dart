import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
class LaunchNavigation extends StatefulWidget {
  static const String title = "Route Request and Launch Navigation";

  @override
  LaunchNavigationState createState() => LaunchNavigationState();
}

class LaunchNavigationState extends State<LaunchNavigation> {
  List<DirectionsRoute> routes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LaunchNavigation.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 8)),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  onPressed: () {
                    _fetchRoute();
                  },
                  child: const Text("Fetch Route"),
                ),
                const Padding(padding: EdgeInsets.only(left: 8)),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(routes.isEmpty ? Colors.grey : Colors.blueAccent),
                      enableFeedback: routes.isNotEmpty),
                  onPressed: () {
                    _startNavigation();
                  },
                  child: const Text("Start Navigation"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text("route info: ${routes.isEmpty ? "" : routes.first.geometry ?? ""}"),
            )
          ],
        ),
      ),
    );
  }

  void _fetchRoute() async {
    LatLng origin = LatLng(1.312533169133601, 103.75986708439264);
    LatLng dest = LatLng( 1.310473772283314, 103.77982271935586);

    RouteRequestParams requestParams = RouteRequestParams(
      origin: origin,
      destination: dest,
      // waypoints: [Coordinate(latitude: wayP2.latitude, longitude: wayP2.longitude)],
      // overview: ValidOverview.simplified,
      // avoid: [SupportedAvoid.toll, SupportedAvoid.ferry],
      // option: SupportedOption.flexible,
      // truckSize: [200, 200, 600],
      // truckWeight: 100,
      // unit: SupportedUnits.imperial,
      mode: ValidModes.car,
      geometryType: SupportedGeometry.polyline,
    );

    await NBNavigation.fetchRoute(requestParams, (routes, error) async {
      if (routes.isNotEmpty) {
        setState(() {
          this.routes = routes;
        });
      } else if (error != null) {
        print("====error====${error}");
      }
    });
  }

  void _startNavigation() {
    if (routes.isEmpty) return;
    NavigationLauncherConfig config = NavigationLauncherConfig(route: routes.first, routes: routes);
    config.locationLayerRenderMode = LocationLayerRenderMode.GPS;
    config.enableDissolvedRouteLine = false;
    config.shouldSimulateRoute = true;
    config.themeMode = NavigationThemeMode.system;
    config.useCustomNavigationStyle = false;
    NBNavigation.startNavigation(config);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(LaunchNavigation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
