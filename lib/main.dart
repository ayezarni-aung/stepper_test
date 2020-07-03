import 'package:flutter/material.dart';
import 'package:mytest/hello_stepper.dart';
import 'package:mytest/test_gridview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: TestGridView(),
    );
  }
}
