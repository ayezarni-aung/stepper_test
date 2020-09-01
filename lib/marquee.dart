import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class HelloMaequee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Marquee(
        text: 'Some sample text that takes some space.',
        style: TextStyle(fontWeight: FontWeight.bold),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        pauseAfterRound: Duration(seconds: 1),
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}
