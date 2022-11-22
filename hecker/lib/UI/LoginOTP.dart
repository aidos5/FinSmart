import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/Model/UserCredential.dart' as UserCredential;
import 'package:hecker/Number.dart';
import 'package:hecker/Password.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hecker/Signup.dart';
import 'package:hecker/UI/LoginPIN.dart';
import 'package:localstorage/localstorage.dart';

import '../Model/ModelItem.dart';

class LoginOTP extends StatefulWidget {
  LoginOTP({Key? key}) : super(key: key);

  String? phoneNo;
  LoginOTP.withPh({required this.phoneNo});

  @override
  State<LoginOTP> createState() => _LoginOTPState(phoneNo: phoneNo);
}

class _LoginOTPState extends State<LoginOTP> {
  String? phoneNo;
  _LoginOTPState({required this.phoneNo});

  String? verificationCode;

  var localStorageItems = LocalStorage('items.json');

  var localStorageUser = new LocalStorage('userCred.json');
  var localStorageShop = new LocalStorage('shopDetail.json');

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
        child: SizedBox(
          width: screenwidth,
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
                      // Get user data and store it in local storage
                      var userCredDoc = FirebaseFirestore.instance
                          .collection("userCreds")
                          .doc("${phoneNo}");

                      var userCredDocData = await userCredDoc.get();

                      if (userCredDocData.exists) {
                        UserCredential.UserCredential userCred =
                            UserCredential.UserCredential.fromJson(
                                userCredDocData.data()!);

                        await localStorageUser.setItem('user', userCred);

                        var shopDetailDoc = userCredDoc
                            .collection("shopDetail")
                            .doc("shopDetail");

                        var shopDetailDocData = await shopDetailDoc.get();

                        if (!shopDetailDocData.exists) {
                          showCreateAccountError();
                          return;
                        }

                        await localStorageShop.setItem('shop',
                            ShopDetail.fromJson(shopDetailDocData.data()!));

                        FirebaseFirestore.instance
                            .collection('transactions')
                            .doc('category')
                            .collection('pincode')
                            .doc('shopid')
                            .collection('items')
                            .snapshots()
                            .map((snapshot) => snapshot.docs
                                .map((doc) => ModelItem.fromJson(doc.data()))
                                .toList())
                            .listen((event) async {
                          List<ModelItem> allItems = [];
                          for (ModelItem mi in event) {
                            allItems.add(mi);
                          }

                          print("yeah boi loaded items");

                          List<dynamic> allItemString = allItems
                              .map((e) => jsonEncode(e.toJson()))
                              .toList();
                          await localStorageItems.setItem(
                              'items', jsonEncode(allItemString));
                        });

                        print("You are logged in!\n" + value.toString());

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPIN()),
                            (route) => false);
                      } else {
                        showCreateAccountError();
                      }
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

  showCreateAccountError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content:
                Text("Your Details doesn't exist! Please Create an account..."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Number()),
                        (route) => false);
                  },
                  child: Text("Ok"))
            ],
          );
        });
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
