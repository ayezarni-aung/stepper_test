import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAccountProfile extends StatefulWidget {
  @override
  _GoogleAccountProfileState createState() => _GoogleAccountProfileState();
}

class _GoogleAccountProfileState extends State<GoogleAccountProfile> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "431109733179-7rvl1jh8kg8boflto1rffm7tbu55d8th.apps.googleusercontent.com",
  );
  GoogleSignInAccount account;
  GoogleSignInAuthentication auth;
  bool gotProfile;
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return gotProfile
        ? Scaffold(
            appBar: AppBar(
              title: Text("Google"),
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    googleSignIn.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                ),
              ],
            ),
            body: Center(
              child: Container(
                child: Column(
                  children: [
                    Image.network(
                      account.photoUrl,
                      height: 100,
                    ),
                    Text(account.displayName),
                    Text(account.email),
                  ],
                ),
              ),
            ),
          )
        : LinearProgressIndicator();
  }

  void getProfile() async {
    await googleSignIn.signInSilently();
    account = googleSignIn.currentUser;
    auth = await account.authentication;
    setState(() {
      gotProfile = true;
    });
  }
}
