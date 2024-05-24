import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_navigation_flutter/route/map_controller_wrapper.dart';

class DrawRouteLine extends StatefulWidget {
  static const String title = "Draw Route Line";

  @override
  DrawRouteLineState createState() => DrawRouteLineState();
}

class DrawRouteLineState extends State<DrawRouteLine> {
  NextbillionMapController? controller;
  List<DirectionsRoute> routes = [];
  late NavNextBillionMap navNextBillionMap;

  LatLng origin = const LatLng(
    17.457302037173775,
    78.37463792413473,
  );
  LatLng dest = const LatLng(
    17.466320809357967,
    78.3726774987914,
  );

  bool enableAlternativeRoutes = true;
  bool enableRouteDurationSymbol = true;

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  void _onStyleLoaded() async {
    if (controller != null) {
      navNextBillionMap =
          await NavNextBillionMap.create(MapControllerWrapper(controller!));
    }
  }

  _onMapClick(Point<double> point, LatLng coordinates) {
    navNextBillionMap.addRouteSelectedListener(coordinates,
        (selectedRouteIndex) {
      if (routes.isNotEmpty && selectedRouteIndex != 0) {
        var selectedRoute = routes[selectedRouteIndex];
        routes.removeAt(selectedRouteIndex);
        routes.insert(0, selectedRoute);
        setState(() {
          routes = routes;
        });
        navNextBillionMap.drawRoute(routes);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(DrawRouteLine.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
              child: NBMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(origin.latitude, origin.longitude),
                  zoom: 13.0,
                ),
                onStyleLoadedCallback: _onStyleLoaded,
                onMapClick: _onMapClick,
              ),
            ),
            _buttonWidget(),
            _switchButton(),
          ],
        ),
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
      alternatives: true,
      mode: ValidModes.car,
    );

    DirectionsRouteResponse routeResponse =
        await NBNavigation.fetchRoute(requestParams);
    if (routeResponse.directionsRoutes.isNotEmpty) {
      setState(() {
        routes = routeResponse.directionsRoutes;
      });
      drawRoutes(routes);
    } else if (routeResponse.message != null) {
      print(
          "====error====${routeResponse.message}===${routeResponse.errorCode}");
    }
  }

  void _startNavigation() {
    if (routes.isEmpty) return;
    NavigationLauncherConfig config =
        NavigationLauncherConfig(route: routes.first, routes: routes);
    config.locationLayerRenderMode = LocationLayerRenderMode.gps;
    config.themeMode = NavigationThemeMode.system;
    config.useCustomNavigationStyle = false;
    NBNavigation.startNavigation(config);
  }

  Future<void> drawRoutes(List<DirectionsRoute> routes) async {
    navNextBillionMap.clearRoute();
    navNextBillionMap.drawRoute(routes);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buttonWidget() {
    return Padding(
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
                backgroundColor: MaterialStateProperty.all(
                    routes.isEmpty ? Colors.grey : Colors.blueAccent),
                enableFeedback: routes.isNotEmpty),
            onPressed: () {
              _startNavigation();
            },
            child: const Text("Start Navigation"),
          ),
        ],
      ),
    );
  }

  _switchButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Display Alternative Route"),
              Switch(
                  value: enableAlternativeRoutes,
                  onChanged: (value) {
                    setState(() {
                      enableAlternativeRoutes = value;
                    });
                    navNextBillionMap.toggleAlternativeVisibilityWith(value);
                  })
            ],
          ),
          Row(
            children: [
              Text("Display Route Duration Symbol"),
              Switch(
                  value: enableRouteDurationSymbol,
                  onChanged: (value) async {
                    setState(() {
                      enableRouteDurationSymbol = value;
                    });
                    navNextBillionMap.toggleDurationSymbolVisibilityWith(value);
                  })
            ],
          )
        ],
      ),
    );
  }
}
