import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInDemo extends StatefulWidget {
  @override
  _GoogleSignInDemoState createState() => _GoogleSignInDemoState();
}

class _GoogleSignInDemoState extends State<GoogleSignInDemo> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "431109733179-7rvl1jh8kg8boflto1rffm7tbu55d8th.apps.googleusercontent.com",
  );
  bool isLoggined = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: RaisedButton(
            onPressed: () {
              startLogin();
            },
            child: Text("Tap to sign in "),
          ),
        ),
      ),
    );
  }

  void startLogin() async {
    await googleSignIn.signOut();
    GoogleSignInAccount user = await googleSignIn.signIn();
    print("login");
    if (user == null) {
      print("sign in faliled");
    } else {
      // Navigator.pushReplacementNamed(context, "/");
    }
  }
}
