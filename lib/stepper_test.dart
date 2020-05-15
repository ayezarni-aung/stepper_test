import 'package:flutter/material.dart';

class StepperTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              
              Container(
                height: 18,
                width: 1,
                color: Colors.green,
              ),
              Container(
                height: 18,
                width: 1,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
