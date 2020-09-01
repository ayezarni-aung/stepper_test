import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class FacebookLoginDemo extends StatefulWidget {
  @override
  _FacebookLoginDemoState createState() => _FacebookLoginDemoState();
}

class _FacebookLoginDemoState extends State<FacebookLoginDemo> {
  bool isLoggedIn = false;
  Map userProfile;
  final facebookLogIn = FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';
  Future<Null> _loginWithFB() async {
    final result = await facebookLogIn.logInWithReadPermissions(['email']);
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final token = accessToken.token;
        var graphResponse = await http.get(
            "https://graph.facebook.com/v8.0/me?fields=id%2Cname%2Cemail%2Cbirthday%2Clikes%2Cpicture&access_token=$token");
        final profile = JSON.jsonDecode(graphResponse.body);
        print("Show data:" + profile['name']);
        // print(profile['likes'].length);
        // var a = profile['likes'];
        // var b = a['data'];
        // print(b.length);
        // b.forEach((f) => print(f['name']));
        // profile['likes'].forEach((f) => print(f['name']));
        setState(() {
          userProfile = profile;
          isLoggedIn = true;
        });
        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelledByUser");
        setState(() {
          isLoggedIn = false;
        });
        break;
      case FacebookLoginStatus.error:
        print("error");
        isLoggedIn = false;
        break;
    }
  }

  Future<Null> _logout() async {
    await facebookLogIn.logOut();
    setState(() {
      isLoggedIn = false;
    });
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    userProfile["picture"]["data"]["url"],
                    width: 50,
                    height: 50,
                  ),
                  Text(userProfile['name']),
                  OutlineButton(
                    onPressed: () {
                      _logout();
                    },
                    child: Text("Logout"),
                  ),
                ],
              )
            : OutlineButton(
                onPressed: () {
                  _loginWithFB();
                },
                child: Text("Login with facebook"),
              ),
      ),
    );
  }
}
