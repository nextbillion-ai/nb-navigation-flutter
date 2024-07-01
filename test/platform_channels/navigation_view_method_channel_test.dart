import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelNavigationView', () {
    const MethodChannel channel = MethodChannel('flutter_nb_navigation/1');
    const EventChannel eventChannel = EventChannel('flutter_nb_navigation/1/events');

    MethodChannelNavigationView navigationView = MethodChannelNavigationView();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'stopNavigation') {
          return null;
        }
        return null;
      });

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(eventChannel.name, (ByteData? message) async {
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(eventChannel.name, null);
    });

    test('initPlatform initializes MethodChannel and EventChannel', () async {
      await navigationView.initPlatform(1);
      expect(navigationView.getMethodChannel, isNotNull);
      expect(navigationView.getEventChannel(), isNotNull);
    });

    test('stopNavigation calls method channel', () async {
      await navigationView.initPlatform(1);
      await navigationView.stopNavigation();
      // Validate if the method was called correctly
    });

    test('dispose sets channels to null', () async {
      await navigationView.initPlatform(1);
      navigationView.dispose();
      expect(navigationView.getMethodChannel(), isNull);
      expect(navigationView.getEventChannel(), isNull);
    });

    test('handleMethodCall processes method calls correctly', () async {
      // Setup callbacks to verify
      bool navigationCancellingCalled = false;
      bool navigationRunningCalled = false;
      bool arriveAtWaypointCalled = false;
      bool rerouteFromLocationCalled = false;

      navigationView.setOnNavigationCancellingCallback(() {
        navigationCancellingCalled = true;
      });

      navigationView.setOnNavigationRunningCallback(() {
        navigationRunningCalled = true;
      });

      navigationView.setOnArriveAtWaypointCallback((_) {
        arriveAtWaypointCalled = true;
      });

      navigationView.setOnRerouteFromLocationCallback((_) {
        rerouteFromLocationCalled = true;
      });

      await navigationView.initPlatform(1);

      await navigationView.handleMethodCall(const MethodCall('onNavigationCancelling'));
      await navigationView.handleMethodCall(const MethodCall('onNavigationReady'));
      await navigationView.handleMethodCall(const MethodCall('onArriveAtWaypoint'));
      await navigationView.handleMethodCall(const MethodCall('willRerouteFromLocation'));

      expect(navigationCancellingCalled, isTrue);
      expect(navigationRunningCalled, isTrue);
      expect(arriveAtWaypointCalled, isTrue);
      expect(rerouteFromLocationCalled, isTrue);
    });
  });
}
