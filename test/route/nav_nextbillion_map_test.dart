import 'package:flutter/painting.dart';
import 'package:mockito/annotations.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_navigation_flutter/route/map_controller_wrapper.dart';
import 'package:nb_navigation_flutter/util/asset_manager.dart';
import 'package:test/test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'nav_nextbillion_map_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IMapController>(), MockSpec<IAssetManager>()])
void main() {
  group('NavNextBillionMap', () {
    late NavNextBillionMap navNextBillionMap;

    setUp(() async {
      var assetManager = MockIAssetManager();
      // when(assetManager.loadImage(any)).thenAnswer((_) async => null);
      // when(assetManager.loadImageFromAsset(any)).thenAnswer((_) async => null);
      navNextBillionMap =
          await NavNextBillionMap.createForTest(MockIMapController(), assetManager: assetManager);
    });

    test('should create NavNextBillionMap', () {
      expect(navNextBillionMap, isNotNull);
    });

    test('should add route selected listener', () {
      LatLng origin = const LatLng(1.312533169133601, 103.75986708439264);
      LatLng dest = const LatLng(1.310473772283314, 103.77982271935586);

      navNextBillionMap.addRouteSelectedListener(origin, (selectedRouteIndex) {
        expect(selectedRouteIndex, equals(0));
      });

      navNextBillionMap.addRouteSelectedListener(dest, (selectedRouteIndex) {
        expect(selectedRouteIndex, equals(0));
      });
    });

    test('should add route selected listener', () {
      LatLng origin = const LatLng(1.312533169133601, 103.75986708439264);
      LatLng dest = const LatLng(1.310473772283314, 103.77982271935586);

      navNextBillionMap.addRouteSelectedListener(origin, (selectedRouteIndex) {
        expect(selectedRouteIndex, equals(0));
      });

      navNextBillionMap.addRouteSelectedListener(dest, (selectedRouteIndex) {
        expect(selectedRouteIndex, equals(0));
      });
    });

    test('should get route line properties', () {
      const routeLineStyle = RouteLineProperties(
          routeDefaultColor: Color(0xFFE97F2F),
          routeScale: 1.0,
          alternativeRouteScale: 1.0,
          routeShieldColor: Color(0xFF54E910),
          durationSymbolPrimaryBackgroundColor: Color(0xFFE97F2F));

      expect(routeLineStyle.routeDefaultColor, equals(const Color(0xFFE97F2F)));
      expect(routeLineStyle.routeScale, equals(1.0));
      expect(routeLineStyle.alternativeRouteScale, equals(1.0));
      expect(routeLineStyle.routeShieldColor, equals(const Color(0xFF54E910)));
      expect(routeLineStyle.durationSymbolPrimaryBackgroundColor,
          equals(const Color(0xFFE97F2F)));
    });
  });
}
