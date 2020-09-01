import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

// ignore: must_be_immutable
class SMSVerify extends StatefulWidget {
  String code;

  SMSVerify({Key key, this.code}) : super(key: key);
  @override
  _SMSVerifyState createState() => _SMSVerifyState();
}

class _SMSVerifyState extends State<SMSVerify> {
  @override
  void initState() {
    super.initState();
    listenOTP();
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("SMS Verification"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: PinFieldAutoFill(
                  controller: _controller,
                  codeLength: 4,
                  onCodeChanged: (val) {
                    _controller.text = val;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listenOTP() async {
    await SmsAutoFill().listenForCode;
  }
}
