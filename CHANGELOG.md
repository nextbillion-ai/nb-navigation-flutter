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
