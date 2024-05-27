// Mocks generated by Mockito 5.4.4 from annotations
// in nb_navigation_flutter/test/platform_channels/nb_navigation_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:typed_data' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:nb_maps_flutter/nb_maps_flutter.dart' as _i5;
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDirectionsRouteResponse_0 extends _i1.SmartFake
    implements _i2.DirectionsRouteResponse {
  _FakeDirectionsRouteResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NBNavigationPlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockNBNavigationPlatform extends _i1.Mock
    implements _i2.NBNavigationPlatform {
  MockNBNavigationPlatform() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set navigationExitCallback(
          _i2.OnNavigationExitCallback? _navigationExitCallback) =>
      super.noSuchMethod(
        Invocation.setter(
          #navigationExitCallback,
          _navigationExitCallback,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<_i2.DirectionsRouteResponse> fetchRoute(
          _i2.RouteRequestParams? routeRequestParams) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchRoute,
          [routeRequestParams],
        ),
        returnValue: _i3.Future<_i2.DirectionsRouteResponse>.value(
            _FakeDirectionsRouteResponse_0(
          this,
          Invocation.method(
            #fetchRoute,
            [routeRequestParams],
          ),
        )),
      ) as _i3.Future<_i2.DirectionsRouteResponse>);

  @override
  _i3.Future<void> startNavigation(
          _i2.NavigationLauncherConfig? launcherConfig) =>
      (super.noSuchMethod(
        Invocation.method(
          #startNavigation,
          [launcherConfig],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> startPreviewNavigation(_i2.DirectionsRoute? route) =>
      (super.noSuchMethod(
        Invocation.method(
          #startPreviewNavigation,
          [route],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<String> getRoutingBaseUri() => (super.noSuchMethod(
        Invocation.method(
          #getRoutingBaseUri,
          [],
        ),
        returnValue: _i3.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #getRoutingBaseUri,
            [],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<void> setRoutingBaseUri(String? baseUri) => (super.noSuchMethod(
        Invocation.method(
          #setRoutingBaseUri,
          [baseUri],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<int> findSelectedRouteIndex(
    _i5.LatLng? clickPoint,
    List<List<_i5.LatLng>>? coordinates,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #findSelectedRouteIndex,
          [
            clickPoint,
            coordinates,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<String> getFormattedDuration(num? durationSeconds) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFormattedDuration,
          [durationSeconds],
        ),
        returnValue: _i3.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #getFormattedDuration,
            [durationSeconds],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<void> setOnNavigationExitCallback(
          _i2.OnNavigationExitCallback? navigationExitCallback) =>
      (super.noSuchMethod(
        Invocation.method(
          #setOnNavigationExitCallback,
          [navigationExitCallback],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<_i6.Uint8List?> captureRouteDurationSymbol(
    _i2.DirectionsRoute? route,
    bool? isPrimaryRoute,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #captureRouteDurationSymbol,
          [
            route,
            isPrimaryRoute,
          ],
        ),
        returnValue: _i3.Future<_i6.Uint8List?>.value(),
      ) as _i3.Future<_i6.Uint8List?>);

  @override
  _i3.Future<_i6.Uint8List?> captureRouteWaypoints(int? waypointIndex) =>
      (super.noSuchMethod(
        Invocation.method(
          #captureRouteWaypoints,
          [waypointIndex],
        ),
        returnValue: _i3.Future<_i6.Uint8List?>.value(),
      ) as _i3.Future<_i6.Uint8List?>);

  @override
  _i3.Future<bool> setUserId(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #setUserId,
          [userId],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<String?> getUserId() => (super.noSuchMethod(
        Invocation.method(
          #getUserId,
          [],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<String?> getNBId() => (super.noSuchMethod(
        Invocation.method(
          #getNBId,
          [],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);
}