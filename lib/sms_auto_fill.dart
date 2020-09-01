import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SmsAutoFillDemo extends StatefulWidget {
  @override
  _SmsAutoFillDemoState createState() => _SmsAutoFillDemoState();
}

class _SmsAutoFillDemoState extends State<SmsAutoFillDemo> {
  String _code;
  String signature = "{{ app signature }}";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  int _otp, _minOtpValue, _maxOtpValue;
  void generateOtp([int min = 1000, int max = 9999]) {
    _minOtpValue = min;
    _maxOtpValue = max;
    _otp = _minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue);
  }

  TextEditingController phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: phoneNumber,
              maxLines: 1,
              decoration: InputDecoration(labelText: "9xxxxxxxxx"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text('send'),
            onPressed: () {
              SmsSender sender = new SmsSender();
              String phone = "+95" + phoneNumber.text;
              print(phone);
              generateOtp(
                1000,
                9999,
              );
              sender.sendSms(
                SmsMessage(
                  phone,
                  'Your OTP is : ' + _otp.toString(),
                ),
              );

              print(_otp);
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>);
            },
          ),
        ],
      ),
    );
  }
}
