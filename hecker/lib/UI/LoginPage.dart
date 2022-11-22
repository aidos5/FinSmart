import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/MainPage.dart';
import 'package:hecker/UI/Colors.dart';
import 'package:hecker/UI/LoginOTP.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:hecker/Number.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hecker/firebase_options.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController NameController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FinSmart',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: screenwidth,
          height: screenheight,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Mobile Number',
                  style: TextStyle(fontSize: 37),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenwidth / 1.5,
                  child: TextField(
                    showCursor: true,
                    keyboardType: TextInputType.number,
                    controller: NameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Mobile Number',
                      labelStyle: TextStyle(fontSize: 17),
                      enabledBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenheight / 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenwidth / 2,
                  child: ElevatedButton(
                    onPressed: (() {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginOTP.withPh(
                                    phoneNo: NameController.text,
                                  )),
                          (route) => false);
                    }),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Not Registered?',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (() {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Number()),
                        (route) => false);
                  }),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      decoration: (TextDecoration.underline),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
