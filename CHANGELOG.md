## v0.3.6, May 8, 2024
* Remove unnecessary await in the NavNextbillionMap

## v0.3.5, May 7, 2024
* Update nb_maps_flutter dependency to 0.3.4
* Refactor the way to init the NavNextBillionMap object
  * await NavNextBillionMap.init(controller)

## v0.3.4, Apr 24, 2024
* Update nb_maps_flutter dependency to 0.3.1

## v0.3.3, Apr 10, 2024
* Remove the restriction on the initialization timing of the NavNextBillionMap object


## v0.3.2, Apr 9, 2024
* Update the android navigation native framework to 1.2.5
* Update iOS navigation native framework from 1.3.3


## v0.3.1, Dec 11, 2023
* Update the android navigation native framework to 1.2.0
* Update iOS navigation native framework from 1.2.12
* Add avoid none option in route request params
  * SupportedAvoid.none to avoid noting during the route.


## v0.3.0, Nov 28, 2023
* Update the android navigation native framework to 1.1.8
* Update nb_maps_flutter Plugin to 0.3.0


## v0.2.1, Nov 8, 2023
* Update the android navigation native framework to 1.1.5
* Update iOS navigation native framework from 1.2.11
* Support previewing navigation processes based on a given route
  * NBNavigation.startPreviewNavigation(route)
* Support to specify the callback that will be executed when user exit navigation
  * NBNavigation.setOnNavigationExitCallback(callback)


## v0.2.0, Sept 26, 2023
* Update the android navigation native framework to 1.0.7
* Update iOS navigation native framework from 1.2.6
* Update nb_maps_flutter dependency to 0.2.0
* Change the route request params geometryType to geometry
  * routeRequestParams.geometry = SupportedGeometry.polyline6
* Support animate map camera into bounds with route points
  *  var latLngBounds = LatLngBounds.fromMultiLatLng(multiPoints);
     controller?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, top: 50, left: 50, right: 50, bottom: 50));


## v0.1.8, Sept 15, 2023
* Update nb_maps_flutter dependency from 0.1.5 to 0.1.6
* Update the route wayPoint label style


## v0.1.7, Sep 05, 2023
* Update the android navigation native framework from 1.0.5 to 1.0.6
* Update iOS navigation native framework from 1.2.1 to 1.2.3
  * Fix voice spoken issue
  * Fix lane voice instructions issue
* Refactor the way to custom navigation style (iOS)
* Fix sometimes destination icon missing issue (Android)


## v0.1.6, August 17, 2023
* Update nb_maps_flutter dependency from 0.1.1 to 0.1.5
* Update the android navigation native framework from 1.0.0 to 1.0.5
* Update iOS navigation native framework from 1.1.5 to 1.2.1
* Update the default map style
* Support to custom the routing baseUri


## v0.1.5, August 03, 2023
* Update the location coordinate type in RouteRequestParams
* Complete the route result module
* Update iOS framework


## v0.1.4, July 24, 2023
* Fix Navigation Reroute issue
* Add permissions annotation


## v0.1.0, July 19, 2023
* Maps Plugin
* Support fetch route
  * RouteRequestParams
* Support draw route line on MapView
* Support alternative routes
  * Toggle alternative line visibility
  * Toggle Route duration symbol visibility
* Launch Navigation with given route
  * route
  * routes (all routes contain alternative routes)
  * themeMode: system(default), light, dark
  * locationLayerRenderMode: default LocationLayerRenderMode.GPS
  * enableDissolvedRouteLine: default true
* Customize Route line appearance
  * route line Shield Color
  * alternative Route line ShieldColor
  * route width
  * route color
  * alternative route color
  * route origin marker image
  * route destination marker image
* Customize Navigation View appearance
