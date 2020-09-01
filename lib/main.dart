import 'package:flutter/material.dart';
import 'package:mytest/facebook_login.dart';
import 'package:mytest/google_profile.dart';
import 'package:mytest/google_sign_in.dart';
import 'package:mytest/google_sign_up.dart';
import 'package:mytest/hello_stepper.dart';
import 'package:mytest/home.dart';
import 'package:mytest/marquee.dart';
import 'package:mytest/see_less.dart';
import 'package:mytest/see_more.dart';
import 'package:mytest/sms.dart';
import 'package:mytest/sms_auto_fill.dart';
import 'package:mytest/sms_otp_code.dart';
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
      routes: {
        '/': (_) => Home(),
        '/login': (_) => GoogleSignInDemo(),
        '/profile': (_) => GoogleAccountProfile(),
        '/sms': (_) => SMSFill(),
      },
    );
  }
}
