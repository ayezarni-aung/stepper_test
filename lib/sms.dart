import 'package:flutter/material.dart';
import 'package:mytest/sms_otp_code.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SMSFill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () async {
                  final signature = await SmsAutoFill().getAppSignature;
                  print(signature);
                  final code = SmsAutoFill().listenForCode;
                  print("code:" + code.toString());
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SMSVerify()));
                },
                child: Text("SMS Verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
