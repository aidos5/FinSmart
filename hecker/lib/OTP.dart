import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hecker/Password.dart';

class OTP extends StatefulWidget {
  OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('FinSmart')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: screenwidth,
          height: screenheight,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: const Text(
                'Enter OTP',
                style: TextStyle(fontSize: 37),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/otp.jpg',
                height: screenheight / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OtpTextField(
                numberOfFields: 5,
                enabledBorderColor: Colors.black,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {}, // end onSubmit
              ),
            ),
            RaisedButton(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                textColor: Colors.white,
                child: Text("Submit"),
                onPressed: (() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Password()),
                      (route) => false);
                }))
          ]),
        ),
      ),
    );
  }
}
