import 'package:flutter/material.dart';

class WaypointNumberView extends StatelessWidget {
  final int index;
  const WaypointNumberView(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.fromBorderSide(
            BorderSide(color: Color(0xFF1F1F1F), width: 0.8),
          )),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Text(
          index.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 8),
        ),
      ),
    );
  }
}
