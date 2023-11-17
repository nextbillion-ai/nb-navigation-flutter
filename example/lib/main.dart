import 'package:flutter/material.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_navigation_flutter_example/custom_navigation_style.dart';
import 'package:nb_navigation_flutter_example/draw_route_line.dart';
import 'package:nb_navigation_flutter_example/launch_navigation.dart';
import 'package:nb_navigation_flutter_example/map_view_style.dart';
import 'package:nb_navigation_flutter_example/navigation_theme_mode.dart';
import 'package:nb_navigation_flutter_example/route_line_style.dart';
import 'package:nb_navigation_flutter_example/track_current_location.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'full_navigation_example.dart';

final Map<String, Widget> _allPages = <String, Widget>{
  FullNavigationExample.title: FullNavigationExample(),
  LaunchNavigation.title: LaunchNavigation(),
  DrawRouteLine.title: DrawRouteLine(),
  TrackCurrentLocation.title: TrackCurrentLocation(),
  RouteLineStyle.title: RouteLineStyle(),
  CustomNavigationStyle.title: CustomNavigationStyle(),
  MapViewStyle.title: MapViewStyle(),
  NavigationTheme.title: NavigationTheme(),
};

class NavigationDemo extends StatefulWidget {
  static const String ACCESS_KEY = String.fromEnvironment("ACCESS_KEY");

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  @override
  void initState() {
    super.initState();
    NextBillion.initNextBillion(NavigationDemo.ACCESS_KEY);
  }

  void _pushPage(BuildContext context, Widget page) async {
    var status = await Permission.location.status;
    if(status.isDenied) {
      await [Permission.location].request();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NBNavigation examples')),
      body: NavigationDemo.ACCESS_KEY.isEmpty
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(height: 1),
              itemBuilder: (_, int index) => ListTile(
                title: Text(_allPages.keys.toList()[index]),
                onTap: () => _pushPage(context, _allPages.values.toList()[index]),
              ),
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Using MapView requires calling Nextbillion.initNextbillion(String accessKey) "
                "before inflating or creating NBMap Widget. ",
          ]
              .map((text) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: NavigationDemo()));
}
