import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:pinput/pinput.dart';

class Passcode extends StatefulWidget {
  Passcode({Key? key}) : super(key: key);

  @override
  State<Passcode> createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {
  final localStorage = new LocalStorage('userCred.json');

  String? userCredJSON;
  bool isInit = false;
  @override
  void initState() {
    // TODO: implement initState
    GetUserCred();
  }

  void GetUserCred() async {
    userCredJSON = await localStorage.getItem('user');
    isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return //(isInit) ?
        Scaffold(
          body: Pinput(
            length: 6,
              onCompleted: (value) {
                // Check with the hash and login user
              },
            ),
        ); //: Text("Loading");
  }
}
