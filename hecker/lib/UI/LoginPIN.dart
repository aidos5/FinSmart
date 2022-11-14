import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/Items.dart';
import 'package:hecker/MainPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pinput/pinput.dart';

import '../Model/UserCredential.dart';

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
                  Text("Enter PIN"),
                  Pinput(
                    length: 6,
                    obscureText: true,
                    controller: pinControlleer,
                  ),
                  SizedBox(
                    height: screenheight / 15,
                    child: MaterialButton(
                      color: Colors.redAccent,
                      onPressed: () async {
                        if (DBCrypt().checkpw(
                            pinControlleer.text, userCred!.passHash!)) {
                          // Login
                          print("right pin");

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (route) => false);
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text(
                                      "Seems like pin you entered is wrong!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK"))
                                  ],
                                );
                              });
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textColor: Colors.white,
                      child: Text("Login"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
