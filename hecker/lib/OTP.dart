import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hecker/Password.dart';

import 'package:firebase_auth/firebase_auth.dart';

class OTP extends StatefulWidget {
  OTP({Key? key}) : super(key: key);

  String? phoneNo;
  OTP.withPh({required this.phoneNo});

  @override
  State<OTP> createState() => _OTPState(phoneNo: phoneNo);
}

class _OTPState extends State<OTP> {
  String? phoneNo;
  _OTPState({required this.phoneNo});

  String? verificationCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhoneNumber();
  }

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
                numberOfFields: 6,
                enabledBorderColor: Colors.black,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when every textfield is filled
                onSubmit: (String pin) async {
                  PhoneAuthCredential cred = PhoneAuthProvider.credential(
                      verificationId: verificationCode ?? "", smsCode: pin);
                  await FirebaseAuth.instance
                      .signInWithCredential(cred)
                      .then((value) async {
                    if (value.user != null) {
                      print("You are logged in!\n" + value.toString());
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Password()),
                      (route) => false);
                    }
                  });
                }, // end onSubmit
              ),
            ),
            // RaisedButton(
            //     color: Colors.redAccent,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(50.0),
            //     ),
            //     textColor: Colors.white,
            //     child: Text("Submit"),
            //     onPressed: (() {
            //       Navigator.of(context).pushAndRemoveUntil(
            //           MaterialPageRoute(builder: (context) => Password()),
            //           (route) => false);
            //     }))
          ]),
        ),
      ),
    );
  }

  verifyPhoneNumber() async {
    print(phoneNo);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneNo}",
        verificationCompleted: (PhoneAuthCredential cred) async {
          await FirebaseAuth.instance
              .signInWithCredential(cred)
              .then((value) async {
            if (value.user != null) {
              print("You are logged in!\n" + value.toString());
            }
          });
        },
        verificationFailed: (verificationFailed) {
          print("Verification Failed! Message = " +
              verificationFailed.message.toString());
        },
        codeSent: (String codeSent, int? resendToken) {
          print("YOYO : " + codeSent);
          verificationCode = codeSent;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationCode = verificationId;
        },
        timeout: Duration(seconds: 60));
  }
}
