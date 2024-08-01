import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';

import 'package:nb_navigation_flutter_example/draw_route_line.dart';
import 'package:nb_navigation_flutter_example/main.dart' as app;

import 'event_simulator.dart';
import 'nav_automator.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      var resultFine = await Process.run('adb', [
        'shell',
        'pm',
        'grant',
        'ai.nextbillion.navigation.nb_navigation_flutter_example',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      print(resultFine.stdout);
      var resultCoarse = await Process.run('adb', [
        'shell',
        'pm',
        'grant',
        'ai.nextbillion.navigation.nb_navigation_flutter_example',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      print(resultCoarse.stdout);
    } catch (e) {
      print('Error while granting permissions: $e');
    }
  });

  testWidgets('verify navigation', (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    final fullNavItem = find.text(DrawRouteLine.title);
    await tester.pumpAndSettle();
    expect(fullNavItem, findsOneWidget);

    // Emulate a tap on the navigation item.
    await tester.tap(fullNavItem);
    await tester.pumpAndSettle();

    final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
    print("object $screenSize ");
    print("object $screenSize ");
    final Offset targetLocation = Offset( tester.view.display.size.width / 2,  tester.view.display.size.height -400);
    print("targetLocation $targetLocation ");
    // await EventSimulator.tapScreen(targetLocation.dx.toInt(), targetLocation.dy.toInt());
    int x = (screenSize.width/2).toInt();
    int y = (screenSize.height - 200).toInt();
    print("xxxxx $x ,  y: $y " );

    // await EventSimulator.tapScreen(x, y);
    // await Future.delayed(const Duration(seconds: 5));

    final mapView = find.byType(NBMap);
    expect(mapView, findsOneWidget);

    final fetchRouteBtn = find.text('Fetch Route');
    expect(fetchRouteBtn, findsOneWidget);

    // Perform the tap action.
    await tester.tap(fetchRouteBtn);
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 3));

    final startNavigationBtn = find.text('Start Navigation');
    expect(startNavigationBtn, findsOneWidget);

    await tester.tap(startNavigationBtn);
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 1));

    final exitBtn = find.text('EXIT');
    expect(exitBtn, findsOneWidget);
  });
}
