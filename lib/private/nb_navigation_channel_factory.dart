part of nb_navigation_flutter;

class NBNavigationChannelFactory {
  static const MethodChannel _nbNavigationChannel = MethodChannel(NBNavigationChannelConstants.nbNavigationChannelName);

  static MethodChannel get nbNavigationChannel => _nbNavigationChannel;

}