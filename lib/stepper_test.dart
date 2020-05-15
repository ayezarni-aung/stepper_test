import 'package:flutter/material.dart';

enum MyStepState {
  indexed,
  issuing,
  complete,
}

class StepperTest extends StatefulWidget {
  @override
  _StepperTestState createState() => _StepperTestState();
}

class _StepperTestState extends State<StepperTest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Align(
                  alignment: Alignment(-1.2, 0),
                  child: Text("Stepper text"),
                ),
                // subtitle: Text("Subtitle stepper text"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 16, 0),
              child: _buildVerticalLine(),
            ),
            _buildVerticalBody(0),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Align(
                alignment: Alignment(-1.2, 0),
                child: Text("Stepper text"),
              ),
              // subtitle: Text("Subtitle stepper text"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleChild() {
    final MyStepState state = MyStepState.complete;

    switch (state) {
      case MyStepState.indexed:
      case MyStepState.issuing:
      case MyStepState.complete:
    }
    return null;
  }

  Widget _buildCircle() {
    return _buildCircleChild();
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: [
        PositionedDirectional(
          start: 8.5, //28
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 16,
            child: Container(
              color: Colors.grey.shade400,
            ),
          ),
        ),
        AnimatedCrossFade(
          sizeCurve: Curves.fastOutSlowIn,
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          crossFadeState: CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0, //60
              end: 24.0,
              bottom: 24.0,
            ),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLine(),
        _buildLine(),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      height: 18,
      width: 1,
      color: Colors.green,
    );
  }
}
