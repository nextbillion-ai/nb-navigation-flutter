import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

class FullNavigationExample extends StatefulWidget {
  static const String title = "Full Navigation Experience Example";

  @override
  FullNavigationExampleState createState() => FullNavigationExampleState();
}

class FullNavigationExampleState extends State<FullNavigationExample> {
  NextbillionMapController? controller;
  List<DirectionsRoute> routes = [];
  late NavNextBillionMap navNextBillionMap;
  Symbol? mapMarkerSymbol;

  String locationTrackImage = "assets/location_on.png";
  UserLocation? currentLocation;
  List<LatLng> waypoints = [];

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    if (controller != null) {
      navNextBillionMap = NavNextBillionMap(controller!);
      loadAssetImage();
    }
    Fluttertoast.showToast(msg: "Long click to select destination and fetch a route");
    Future.delayed(const Duration(milliseconds: 80), () {
      controller?.updateMyLocationTrackingMode(MyLocationTrackingMode.Tracking);
    });
  }

  _onMapLongClick(Point<double> point, LatLng coordinates) {
    _fetchRoute(coordinates);
  }


  _onMapClick(Point<double> point, LatLng coordinates) {
    navNextBillionMap.addRouteSelectedListener(coordinates, (selectedRouteIndex) {
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

  _onUserLocationUpdate(UserLocation location) {
    currentLocation = location;
  }

  _onCameraTrackingChanged() {
    setState(() {
      locationTrackImage = 'assets/location_off.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NBMap(
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoadedCallback,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 14.0,
          ),
          trackCameraPosition: true,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          onMapLongClick: _onMapLongClick,
          onUserLocationUpdated: _onUserLocationUpdate,
          onCameraTrackingDismissed: _onCameraTrackingChanged,
          onMapClick: _onMapClick,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Image(
                      image: AssetImage(locationTrackImage),
                      width: 28,
                      height: 28,
                    ),
                    onTap: () {
                      controller?.updateMyLocationTrackingMode(MyLocationTrackingMode.Tracking);
                      setState(() {
                        locationTrackImage = 'assets/location_on.png';
                      });
                    }),
              ),
              const Padding(padding: EdgeInsets.only(top: 35)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(routes.isEmpty ? Colors.grey : Colors.blueAccent),
                          enableFeedback: routes.isNotEmpty),
                      onPressed: () {
                        clearRouteResult();
                        waypoints.clear();
                      },
                      child: const Text("Clear Routes")),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(routes.isEmpty ? Colors.grey : Colors.blueAccent),
                          enableFeedback: routes.isNotEmpty),
                      onPressed: () {
                        _startNavigation();
                      },
                      child: const Text("Start Navigation")),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 48)),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Text("route response: ${routeResult}"),
              // ),
            ],
          ),
        )
      ],
    );
  }


  void _fetchRoute(LatLng destination) async {
    if (currentLocation == null) {
      return;
    }
    LatLng origin = currentLocation!.position;
    waypoints.add(destination);
    RouteRequestParams requestParams = RouteRequestParams(
      origin: origin,
      destination: waypoints.last,
      // overview: ValidOverview.simplified,
      // avoid: [SupportedAvoid.toll, SupportedAvoid.ferry],
      // option: SupportedOption.flexible,
      // truckSize: [200, 200, 600],
      // truckWeight: 100,
      // unit: SupportedUnits.imperial,
      alternatives: true,
      mode: ValidModes.car,
      geometryType: SupportedGeometry.polyline,
    );

    if (waypoints.length > 1) {
      requestParams.waypoints = waypoints.sublist(0, waypoints.length - 1);
    }

    await NBNavigation.fetchRoute(requestParams, (routes, error) async {
      if (routes.isNotEmpty) {
        clearRouteResult();
        setState(() {
          this.routes = routes;
        });
        await drawRoutes(routes);
        addImageFromAsset(destination);
      } else if (error != null) {
        print("====error====${error}");
      }
    });
  }

  Future<void> drawRoutes(List<DirectionsRoute> routes) async {
    // navNextBillionMap.toggleDurationSymbolVisibilityWith(false);
    await navNextBillionMap.drawRoute(routes);
  }

  void clearRouteResult() {
    navNextBillionMap.clearRoute();
    controller?.clearSymbols();
    setState(() {
      routes.clear();
    });
  }

  void _startNavigation() {
    if (routes.isEmpty) return;
    NavigationLauncherConfig config = NavigationLauncherConfig(route: routes.first, routes: routes);
    config.locationLayerRenderMode = LocationLayerRenderMode.GPS;
    config.enableDissolvedRouteLine = false;
    config.shouldSimulateRoute = false;
    config.themeMode = NavigationThemeMode.system;
    config.useCustomNavigationStyle = false;
    NBNavigation.startNavigation(config);
  }

  Future<void> loadAssetImage() async {
    final ByteData bytes = await rootBundle.load("assets/map_marker_light.png");
    final Uint8List list = bytes.buffer.asUint8List();
    await controller?.addImage("ic_marker_destination", list);
  }

  Future<void> addImageFromAsset(LatLng coordinates) async {
    controller?.clearSymbols();
    var symbolOptions = SymbolOptions(
      geometry: coordinates,
      iconImage: "ic_marker_destination",
    );
    await controller?.addSymbol(symbolOptions);
    controller?.symbolManager?.setTextAllowOverlap(false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(FullNavigationExample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
