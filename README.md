# Nextbillion Navigation Flutter

## Instroduction
![IMG_0378](https://github.com/nextbillion-ai/nb-navigation-flutter/assets/100656364/b5713d37-4668-4b36-89af-906915aa8388)




## Prerequisites
* Access Key
* Android minSdkVersion 17+
* iOS 11+
* Flutter 3.10+
* Pod 1.11.3+
* Ensure that Build Libraries for Distribution (available under build settings) is set to No.
  <img width="1061" alt="截屏2023-07-20 上午11 22 01" src="https://github.com/nextbillion-ai/nb-navigation-flutter/assets/100656364/641c31b7-3d9a-4337-b5e5-f7808cd0c737">
* Disable the `minify` and `shrinkResource` in the release configuration of Android `build.gradle`
  ```
  buildTypes {
    release {
        minifyEnabled false
        shrinkResources false
    }
  }
  ```

 
## Installation
### Dependency
Add the following dependency to your project pubspec.yaml file to use the NB Navigation Flutter Plugin add the dependency to the pubspec.yaml (change the version to actual version that you want to use):
```
dependencies:
  nb_navigation_flutter: {version}
```

### Import
Import the navigation plugin in your code
```
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
```

### Initialization
To run the Navigation Flutter Plugin you will need to configure the NB Maps Token at the beginning of your flutter app using `NextBillion.initNextBillion(YOUR_ACCESS_KEY)`. 
```
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

class _NavigationDemoState extends State<NavigationDemo> {
  @override
  void initState() {
    super.initState();
    NextBillion.initNextBillion(YOUR_ACCESS_KEY);
  }
}
```

## Required Permissions
### Configuration permissions
You need to grant location permission in order to use the location component of the NB Navigation Flutter Plugin, declare the permission for both platforms:

### Android
Add the following permissions to the manifest:
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

### iOS
Add the following to the Runner/Info.plist to explain why you need access to the location data:
```
 <key>NSLocationWhenInUseUsageDescription</key>
    <string>[Your explanation here]</string>
```

### Observe and Tracking User Location
* add the callback onUserLocationUpdated(UserLocation location)
* animate camera to user location within `onStyleLoadedCallback`
```
void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

_onUserLocationUpdate(UserLocation location) {
    currentLocation = location;
  }

_onStyleLoadedCallback() {
    if (currentLocation != null) {
      controller?.animateCamera(CameraUpdate.newLatLngZoom(currentLocation!.position, 14), duration: Duration(milliseconds: 400));
    }
  }

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
     onUserLocationUpdated: _onUserLocationUpdate,
)
```

## Usage
### NB Maps
If you need to use Maps related functions, for example: Display a Map widget, please refer to NB [Flutter Maps Plugin](https://pub.dev/packages/nb_maps_flutter)

### Fetch Routes
You can request routes with RouteRequestParams using NBNavigation, for the supported params, please refer to [Navigation API](https://docs.nextbillion.ai/docs/navigation/api/navigation)

#### Create RouteRequestParams
```
RouteRequestParams requestParams = RouteRequestParams(
      origin: origin,
      destination: dest,
      // waypoints: [waypoint1, waypoint2],
      // language: 'en',
      // alternatives: true,
      // overview: ValidOverview.simplified,
      // avoid: [SupportedAvoid.toll, SupportedAvoid.ferry],
      // option: SupportedOption.flexible,
      // unit: SupportedUnits.imperial,
      // mode: ValidModes.car,
      // geometry: SupportedGeometry.polyline,
    );
```
#### Fetch routes
Fetch route with requestParams using NBNavigation.fetchRoute(), and get the routes in the route result callback `Callback(List<DirectionsRoute> routes, String error)`
```
await NBNavigation.fetchRoute(requestParams, (routes, error) async { });
```


### Draw routes
After getting the routes, you can draw routes on the map view using `NavNextBillionMap`, If you need to use Maps related functions, for example: Display a Map widget, please refer to NB [Flutter Maps Plugin](https://pub.dev/packages/nb_maps_flutter)

Create `NavNextBillionMap` with `NextbillionMapController` in NBMap widget’s `onStyleLoadedCallback` callback:
```
void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
}

void _onStyleLoaded() {
    if (controller != null) {
      navNextBillionMap = NavNextBillionMap(controller!);
    }
  }
```

#### Draw routes
```
await navNextBillionMap.drawRoute(routes);
```

#### Fit Map camera to route points
```
void fitCameraToBounds(List<DirectionsRoute> routes) {
    List<LatLng> multiPoints = [];
    for (var route in routes) {
       var routePoints = decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
       multiPoints.addAll(routePoints);
    }
    if (multiPoints.isNotEmpty) {
      var latLngBounds = LatLngBounds.fromMultiLatLng(multiPoints);
      controller?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, top: 50, left: 50, right: 50, bottom: 50));
    }
  }

  int _getDecodePrecision(RouteRequestParams? routeOptions) {
    return routeOptions?.geometry == SupportedGeometry.polyline ? PRECISION : PRECISION_6;
  }
```

Clear routes
```
 navNextBillionMap.clearRoute();
```

Toggle Alternative route visibility
```
 navNextBillionMap.toggleAlternativeVisibilityWith(visible);
```

Toggle RouteDurationSymbol visibility
```
 navNextBillionMap.toggleDurationSymbolVisibilityWith(visible);
```

Add RouteSelected Listener. You can add route switching listener in onMapClick callback
```
onMapClick(Point<double> point, LatLng coordinates) {
    navNextBillionMap.addRouteSelectedListener(coordinates, (selectedRouteIndex) {})
}
```

### Start navigation
Start navigation with `NavigationLauncherConfig`
* route: The selected route for directions
* routes: A list of available routes
* themeMode: The theme mode for navigation UI, default value is system
    * system: following system mode
    * light
    * dark
* locationLayerRenderMode: The rendering mode for the location layer, default value is LocationLayerRenderMode.GPS
* shouldSimulateRoute:  Whether to simulate the route during navigation, default value is false
* enableDissolvedRouteLine: Whether to enable the dissolved route line during navigation, default value is true

```
NavigationLauncherConfig config = NavigationLauncherConfig(route: routes.first, routes: routes, shouldSimulateRoute: true);

NBNavigation.startNavigation(config);
```

## UI Components
You can customize the styles of Navigation View

### Android
Add Custom style named `CustomNavigationViewLight` in your android project styles.xml with `parent = "NavigationViewLight"`
```
<style name="CustomNavigationViewLight" parent="NavigationViewLight">
//customize your navigation style
<item name="navViewBannerBackground">@color/color</item>
<item name="navViewBannerPrimaryText">@color/color</item>
...
</style>


<style name="CustomNavigationViewDark" parent="NavigationViewDark">
<item name="navViewBannerBackground">@color/colorAccent</item>

</style>
```

### iOS
Import nb_navigation_flutter in the AppDelegate of  your ios project, customize the Navigation View Style by extending `DayStyle` and `NightStyle`
```
import nb_navigation_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        customStyle()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
     func customStyle() {
        NavStyleManager.customDayStyle = CustomDayStyle()
        NavStyleManager.customNightStyle = CustomNightStyle()
    }
}
```
```
import NbmapNavigation

class CustomDayStyle: DayStyle {
    required init() {
        super.init()
    }
    
    override func apply() {
        super.apply()
        ArrivalTimeLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        ArrivalTimeLabel.appearance().normalTextColor = #color
        BottomBannerContentView.appearance().backgroundColor = #color
    }
}

class CustomNightStyle: NightStyle {
    required init() {
        super.init()
    }
    
    override func apply() {
        super.apply()
        NavigationMapView.appearance().trafficUnknownColor = UIColor.green
    }
}
```

## Running the example code
Please refer to the [RUN_EXAMPLE_CODE.md](https://github.com/nextbillion-ai/nb-navigation-flutter/blob/main/doc/RUN_EXAMPLE_CODE.md)


