## v0.1.6, August 16, 2023
* Update nb_maps_flutter dependency from 0.1.1 to 0.1.4
* Update the android navigation native framework from 1.0.0 to 1.0.3
* Update iOS navigation native framework from 1.1.5 to 1.2.1
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
