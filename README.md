# Nextbillion Navigation Flutter

## Instroduction
![1689854805888](https://github.com/nextbillion-ai/nb-navigation-flutter/assets/100656364/b02a9265-d9d9-4890-ad97-6d281832f1f4)



## Prerequisites
* Access Key
* Android minSdkVersion 17+
* iOS 11+
* Flutter 3.10+
* Pod 1.11.3+
* Ensure that Build Libraries for Distribution (available under build settings) is set to No.
 <img width="1061" alt="截屏2023-07-20 上午11 22 01" src="https://github.com/nextbillion-ai/nb-navigation-flutter/assets/100656364/641c31b7-3d9a-4337-b5e5-f7808cd0c737">


 
## Installation
### Dependency
Add the following dependency to your project pubspec.yaml file to use the NB Navigation Flutter Plugin add the dependency to the pubspec.yaml (change the version to actual version that you want to use):
```
dependencies:
  nb_navigation_flutter: 0.1.0
```

### Import
Import the navigation plugin in your code
```
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
```

### Initialization
To run the Navigation Flutter Plugin you will need to configure the NB Maps Token at the beginning of your flutter app using `NextBillion.initNextBillion(YOUR_ACCESS_KEY)`. 
```
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
```

### iOS
Add the following to the Runner/Info.plist to explain why you need access to the location data:
```
 <key>NSLocationWhenInUseUsageDescription</key>
    <string>[Your explanation here]</string>
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
      // geometryType: SupportedGeometry.polyline,
    );
```
#### Fetch routes
Fetch route with requestParams using NBNavigation.fetchRoute(), and get the routes in the route result callback `Callback(List<DirectionsRoute> routes, String error)`
```
await NBNavigation.fetchRoute(requestParams, (routes, error) async { });
```


### Draw routes
After getting the routes, you can draw routes on the map view using `NavNextBillionMap`

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
Import nb_navigation_flutter in the AppDelegate of  your ios project, customize the navigation view appearance using `customDayStyle` and `customNightStyle`
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
        customDayStyle.arrivalTimeLabelFont = UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        customDayStyle.trafficUnknownColor = UIColor.red
        
        customNightStyle.trafficUnknownColor = UIColor.green
        …
        // customize your navigation style
    }
}
```


