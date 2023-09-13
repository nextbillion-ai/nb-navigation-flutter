import 'package:flutter/material.dart';

class WaypointNumberView extends StatelessWidget {
  int index;
  WaypointNumberView(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Text(
          index.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 10, height: 1.1),
        ),
      ),
    );
  }
}
