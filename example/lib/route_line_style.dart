import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

class RouteLineStyle extends StatefulWidget {
  static const String title = "Customize Route Line Style";

  @override
  RouteLineStyleState createState() => RouteLineStyleState();
}

class RouteLineStyleState extends State<RouteLineStyle> {
  NextbillionMapController? controller;
  List<DirectionsRoute> routes = [];
  late NavNextBillionMap navNextBillionMap;

  LatLng origin = LatLng(1.312533169133601, 103.75986708439264);
  LatLng dest = LatLng(1.310473772283314, 103.77982271935586);

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  void _onStyleLoaded() async {
    if (controller != null) {
      var routeLineStyle = const RouteLineProperties(
        routeDefaultColor: Color(0xFFE97F2F),
        routeScale: 1.0,
        alternativeRouteScale: 1.0,
        routeShieldColor: Color(0xFF54E910),
        durationSymbolPrimaryBackgroundColor: Color(0xFFE97F2F)
      );
      navNextBillionMap = NavNextBillionMap(controller!, routeLineProperties: routeLineStyle);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RouteLineStyle.title),
      ),
      body: Stack(
        children: [
          NBMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(origin.latitude, 103.76986708439264),
              zoom: 13.0,
            ),
            onStyleLoadedCallback: _onStyleLoaded,
          ),
          _buttonWidget(),
        ],
      ),
    );
  }

  void _fetchRoute() async {
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
    );

    await NBNavigation.fetchRoute(requestParams, (routes, error) async {
      if (routes.isNotEmpty) {
        setState(() {
          this.routes = routes;
        });
        drawRoutes(routes);
      } else if (error != null) {
        print("====error====${error}");
      }
    });
  }

  void _startNavigation() {
    if (routes.isEmpty) return;
    NavigationLauncherConfig config = NavigationLauncherConfig(route: routes.first, routes: routes);
    config.locationLayerRenderMode = LocationLayerRenderMode.GPS;
    config.shouldSimulateRoute = true;
    config.themeMode = NavigationThemeMode.system;
    config.useCustomNavigationStyle = false;
    NBNavigation.startNavigation(config);
  }

  Future<void> drawRoutes(List<DirectionsRoute> routes) async {
    navNextBillionMap.clearRoute();
    await navNextBillionMap.drawRoute(routes);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buttonWidget() {
    return Positioned(
      bottom: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 18.0),
        child: Row(
          children: [
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
      ),
    );
  }

}
