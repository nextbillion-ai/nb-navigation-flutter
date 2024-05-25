import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

import 'nb_navigation_method_channels_test.mocks.dart';



@GenerateMocks([MethodChannel])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MethodChannel channel;
  late NBNavigationMethodChannel methodChannelNBNavigation;
  late DirectionsRoute route;

  setUp(() async {
    channel = MockMethodChannel();
    methodChannelNBNavigation = NBNavigationMethodChannel();
    methodChannelNBNavigation.setMethodChanenl(channel);

    final file = File('test/navigation/route.json');
    final jsonString = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(jsonString);
    route = DirectionsRoute.fromJson(json);
  });

  tearDown(() {});

  test('fetchRoute should return DirectionsRouteResponse', () async {
    LatLng origin = const LatLng(1.312533169133601, 103.75986708439264);
    LatLng dest = const LatLng(1.310473772283314, 103.77982271935586);

    final routeRequestParams =
        RouteRequestParams(origin: origin, destination: dest);

    final expectedResponse = DirectionsRouteResponse(
      directionsRoutes: [],
      message: 'Test message',
      errorCode: 0,
    );

    when(channel.invokeMethod<Map<String, dynamic>>('route/fetchRoute', any))
        .thenAnswer((_) async => {
              'directionsRoutes': [],
              'message': 'Test message',
              'errorCode': 0,
            });

    final response =
        await methodChannelNBNavigation.fetchRoute(routeRequestParams);

    expect(response.message, equals(expectedResponse.message));
    expect(response.errorCode, equals(expectedResponse.errorCode));
    expect(
        response.directionsRoutes, equals(expectedResponse.directionsRoutes));
  });

  //Assume Platform.IOS == false;
  test('startNavigation should invoke method on channel', () async {
    List<DirectionsRoute> routes = [route];
    final launcherConfig =
        NavigationLauncherConfig(route: route, routes: routes);
    // final routeOptions = RouteRequestParams.fromJson({});
    final arguments = {
      'launcherConfig': launcherConfig.toJson(),
    };

    when(channel.invokeMethod<Map<String, dynamic>>(
            NBNavigationLauncherMethodID.nbNavigationLauncherMethod, arguments))
        .thenAnswer((_) async => {});

    await methodChannelNBNavigation.startNavigation(launcherConfig);

    verify(channel.invokeMethod(
        NBNavigationLauncherMethodID.nbNavigationLauncherMethod, arguments));
  });

  test('startPreviewNavigation should invoke method on channel', () async {
    final arguments = {
      'route': jsonEncode(route),
    };

    when(channel.invokeMethod<Map<String, dynamic>>(
            NBNavigationLauncherMethodID.nbPreviewNavigationMethod, arguments))
        .thenAnswer((_) async => {});

    await methodChannelNBNavigation.startPreviewNavigation(route);

    verify(channel.invokeMethod(
        NBNavigationLauncherMethodID.nbPreviewNavigationMethod, arguments));
  });

  test('findSelectedRouteIndex should return index', () async {
    const expectedIndex = 0;
    LatLng clickPoint = const LatLng(1.0, 2.0);
    List<List<LatLng>> coordinates = [
      [const LatLng(1.0, 2.0), const LatLng(1.0, 2.0)]
    ];

    when(channel.invokeMethod<int>('route/findSelectedRouteIndex', any))
        .thenAnswer((_) async => expectedIndex);

    final index = await methodChannelNBNavigation.findSelectedRouteIndex(
        clickPoint, coordinates);

    expect(index, equals(expectedIndex));
  });

  test('getRoutingBaseUri should return uri', () async {
    const expectedUri = 'testUri';

    when(channel.invokeMethod<String>(
            NBNavigationLauncherMethodID.nbGetNavigationUriMethod))
        .thenAnswer((_) async => expectedUri);

    final uri = await methodChannelNBNavigation.getRoutingBaseUri();

    expect(uri, equals(expectedUri));
  });

  test('getFormattedDuration should return formatted duration', () async {
    const expectedDuration = '1 min';

    when(channel.invokeMethod<String>(NBRouteMethodID.routeFormattedDuration,
        {"duration": 60.toDouble()})).thenAnswer((_) async => expectedDuration);

    final duration = await methodChannelNBNavigation.getFormattedDuration(60);

    expect(duration, equals(expectedDuration));
  });

  test('captureRouteDurationSymbol should return Uint8List', () async {
    final expectedResponse = Uint8List(0);

    when(channel.invokeMethod<Uint8List>('capture/routeDurationSymbol', any))
        .thenAnswer((_) async => expectedResponse);

    final response =
        await methodChannelNBNavigation.captureRouteDurationSymbol(route, true);

    expect(response, equals(expectedResponse));
  });

  test('captureRouteWaypoints should return Uint8List', () async {
    final expectedResponse = Uint8List(0);

    when(channel.invokeMethod<Uint8List>(
            NBRouteMethodID.navigationCaptureRouteWaypoints, any))
        .thenAnswer((_) async => expectedResponse);

    final response = await methodChannelNBNavigation.captureRouteWaypoints(0);

    expect(response, equals(expectedResponse));
  });
}
