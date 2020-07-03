import 'package:flutter/material.dart';

class MyCrossFadedDemo extends StatefulWidget {
  @override
  _MyCrossFadedDemoState createState() => _MyCrossFadedDemoState();
}

class _MyCrossFadedDemoState extends State<MyCrossFadedDemo> {
  bool firstStateEnabled = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RaisedButton(
          onPressed: () {
            setState(() {
              firstStateEnabled = true;
            });
          },
          child: AnimatedCrossFade(
            crossFadeState: firstStateEnabled
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 500),
            firstChild: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
              height: 100.0,
              width: 100.0,
            ),
            secondChild: Container(),
          ),
        ),
      ),
    );
  }
}
