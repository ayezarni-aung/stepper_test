import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignUp extends StatefulWidget {
  @override
  _GoogleSignUpState createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "431109733179-7rvl1jh8kg8boflto1rffm7tbu55d8th.apps.googleusercontent.com",
  );
  @override
  void initState() {
    chechSigninStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text("Welcome"),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void chechSigninStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isSignin = await googleSignIn.isSignedIn();
    if (isSignin) {
      print("sign in");
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
