part of nb_navigation_flutter;

class NBNavigationChannelConstants {
  static const nbNavigationChannelName = "nb_navigation_flutter";
}

class NBRouteMethodID {
  static const nbFetchRouteMethod = "route/fetchRoute";

  static const nbRouteResultMethod = "route/routeResult";
  static const nbRouteSelectedIndexMethod = "route/findSelectedRouteIndex";
}

class NBNavigationLauncherMethodID {
  static const nbNavigationLauncherMethod = "navigation/startNavigation";
  static const nbGetNavigationUriMethod = "navigation/getBaseUri";
  static const nbSetNavigationUriMethod = "navigation/setBaseUri";
}

class NBNavigationConfigMethodID {
  static const initNBNavigationMethod = "config/initNBNavigation";
}
