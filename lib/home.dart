import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/sms");
                  },
                  child: Text("SMS Test"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
