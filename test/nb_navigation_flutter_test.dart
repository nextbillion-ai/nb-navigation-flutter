import 'package:flutter_test/flutter_test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter_platform_interface.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNbNavigationFlutterPlatform
    with MockPlatformInterfaceMixin
    implements NbNavigationFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NbNavigationFlutterPlatform initialPlatform = NbNavigationFlutterPlatform.instance;

  test('$MethodChannelNbNavigationFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNbNavigationFlutter>());
  });

  test('getPlatformVersion', () async {
    NbNavigationFlutter nbNavigationFlutterPlugin = NbNavigationFlutter();
    MockNbNavigationFlutterPlatform fakePlatform = MockNbNavigationFlutterPlatform();
    NbNavigationFlutterPlatform.instance = fakePlatform;

    expect(await nbNavigationFlutterPlugin.getPlatformVersion(), '42');
  });
}
