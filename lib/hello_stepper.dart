import 'package:flutter/material.dart';
import 'package:mytest/mystepper.dart';
import 'package:mytest/stepper_test.dart';

class HelloStepper extends StatefulWidget {
  @override
  _HelloStepperState createState() => _HelloStepperState();
}

class _HelloStepperState extends State<HelloStepper> {
  int currentStep;

  goto(int step) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: 350,
            width: 350,
            child: MyStepper(
              physics: ClampingScrollPhysics(),
              onCustomStepTapped: (step) {
                currentStep = step;
              },
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Container();
              },
              steps: [
                MyStep(
                  title: Text("Processing"),
                  state: MyStepState.complete,
                  content: Text("Continue processing step"),
                ),
                MyStep(
                  title: Text("Waiting for payment"),
                  state: MyStepState.complete,
                  content: Text("You waiting for payment"),
                ),
                MyStep(
                  title: Text("Issuing ticket"),
                  state: MyStepState.complete,
                  content: Text("Issuing ticket"),
                ),
                MyStep(
                  title: Text("Completed"),
                  state: MyStepState.complete,
                  content: Text("All steps completed"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
