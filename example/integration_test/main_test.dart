import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nb_navigation_flutter_example/draw_route_line.dart';
import 'package:nb_navigation_flutter_example/full_navigation_example.dart';
import 'package:nb_navigation_flutter_example/launch_embedded_navigation_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_navigation_flutter_example/route_line_style.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  const String accessKey = String.fromEnvironment("ACCESS_KEY");
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  NextBillion.initNextBillion(accessKey);
  testWidgets('Launch Embedded Navigation View integration test', (WidgetTester tester) async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Permission.location.request();
    }

    await tester.pumpWidget(
      const MaterialApp(
        home: LaunchEmbeddedNavigationView(),
      ),
    );

    // Verify that the map is created.
    expect(find.byType(NBMap), findsOneWidget);

    // Find the Image widget by its properties.
    final imageFinder = find.byWidgetPredicate((Widget widget) {
      if (widget is Image) {
        if (widget.image is AssetImage) {
          final AssetImage assetImage = widget.image as AssetImage;
          return assetImage.assetName == 'assets/location_on.png';
        }
      }
      return false;
    });
    expect(imageFinder, findsOneWidget);
    await tester.tap(imageFinder);

    // Find the NBMap widget.
    final nbMap = find.byType(NBMap);

    // Wait for the NBMap widget to be fully displayed using runAsync.
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();  // Ensure the tester processes any pending frames.
    expect(nbMap, findsOneWidget);

    await tester.longPressAt(Offset(tester.getCenter(nbMap).dx + 20, tester.getCenter(nbMap).dy + 20));

    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Interact with the "Start Navigation" button.
    final startNavigationButton = find.widgetWithText(ElevatedButton, 'Start Navigation');
    await tester.tap(startNavigationButton);

    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    // Check that the routes are drawn.
    expect(find.textContaining("distanceRemaining:"), findsOneWidget);
    expect(find.textContaining("durationRemaining:"), findsOneWidget);

    // Verify the navigation is started.
    expect(find.byType(NBNavigationView), findsOneWidget);
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('DrawRouteLine integration test', (WidgetTester tester) async {
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Permission.location.request();
    }

    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: DrawRouteLine()));

    // Verify that the map is created.
    expect(find.byType(NBMap), findsOneWidget);
    // Find the NBMap widget.
    final nbMap = find.byType(NBMap);

    // Wait for the NBMap widget to be fully displayed using runAsync.
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();  // Ensure the tester processes any pending frames.
    expect(nbMap, findsOneWidget);

    // Verify the initial state
    expect(find.text('Fetch Route'), findsOneWidget);
    expect(find.text('Start Navigation'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));

    // Simulate fetching the route
    await tester.tap(find.text('Fetch Route'));
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    // Simulate toggling the alternative routes switch
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    // Simulate toggling the route duration symbol switch
    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

  });

  testWidgets('RouteLineStyle integration test', (WidgetTester tester) async {
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Permission.location.request();
    }

    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: RouteLineStyle()));

    // Verify that the map is created.
    expect(find.byType(NBMap), findsOneWidget);
    // Find the NBMap widget.
    final nbMap = find.byType(NBMap);

    // Wait for the NBMap widget to be fully displayed using runAsync.
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();  // Ensure the tester processes any pending frames.
    expect(nbMap, findsOneWidget);

    // Verify the initial state
    expect(find.text('Fetch Route'), findsOneWidget);
    expect(find.text('Start Navigation'), findsOneWidget);

    // Simulate fetching the route
    await tester.tap(find.text('Fetch Route'));
    await Future.delayed(const Duration(seconds: 3));

    await tester.pumpAndSettle();  // Ensure the tester processes any pending frames.
    await Future.delayed(const Duration(seconds: 3));
  });

  testWidgets('Full Navigation Example integration test', (WidgetTester tester) async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Permission.location.request();
    }

    await tester.pumpWidget(
      const MaterialApp(
        home: FullNavigationExample(),
      ),
    );

    // Verify that the map is created.
    expect(find.byType(NBMap), findsOneWidget);

    // Find the Image widget by its properties.
    final imageFinder = find.byWidgetPredicate((Widget widget) {
      if (widget is Image) {
        if (widget.image is AssetImage) {
          final AssetImage assetImage = widget.image as AssetImage;
          return assetImage.assetName == 'assets/location_on.png';
        }
      }
      return false;
    });
    expect(imageFinder, findsOneWidget);
    await tester.tap(imageFinder);

    // Find the NBMap widget.
    final nbMap = find.byType(NBMap);

    // Wait for the NBMap widget to be fully displayed using runAsync.
    await Future.delayed(const Duration(seconds: 2));
    await tester.longPressAt(Offset(tester.getCenter(nbMap).dx + 20, tester.getCenter(nbMap).dy + 20));

    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Interact with the "Start Navigation" button.
    final startNavigationButton = find.widgetWithText(ElevatedButton, 'Start Navigation');
    await tester.tap(startNavigationButton);

    await Future.delayed(const Duration(seconds: 10));
  });

}
