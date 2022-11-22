import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/Items.dart';
import 'package:hecker/MainPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pinput/pinput.dart';

import '../Model/UserCredential.dart';
import 'Colors.dart';

class LoginPIN extends StatefulWidget {
  LoginPIN({Key? key}) : super(key: key);

  @override
  State<LoginPIN> createState() => _LoginPINState();
}

class _LoginPINState extends State<LoginPIN> {
  TextEditingController pinControlleer = new TextEditingController();

  final localStorage = new LocalStorage('userCred.json');

  UserCredential? userCred;
  bool isInit = false;
  @override
  void initState() {
    // TODO: implement initState
    GetUserCred();
  }

  void GetUserCred() async {
    var uC = await localStorage.getItem('user');
    if (uC == null) {
      await localStorage.setItem('user', new UserCredential());
    }

    userCred = await UserCredential.fromJson(localStorage.getItem('user'));

    print(userCred?.toJson());
    isInit = true;
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
          child: Column(
            children: [
              const Text(
                'Set Password',
                style: TextStyle(fontSize: 37),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.lock_outline,
                  size: screenheight / 2.5,
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Text(
                      "Enter PIN",
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.5,
                      ),
                    ),
                  ),
                  Pinput(
                    length: 6,
                    obscureText: true,
                    controller: pinControlleer,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                child: SizedBox(
                  height: screenheight / 15,
                  width: screenwidth / 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false);
                      // if (DBCrypt()
                      //     .checkpw(pinControlleer.text, userCred!.passHash!)) {
                      //   // Login
                      //   print("right pin");

                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text("Error"),
                      //         content:
                      //             Text("Seems like pin you entered is wrong!"),
                      //         actions: [
                      //           TextButton(
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               },
                      //               child: Text("OK"))
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
