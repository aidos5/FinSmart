import 'package:flutter/material.dart';
import 'package:hecker/main.dart';

class AccountDone extends StatefulWidget {
  AccountDone({Key? key}) : super(key: key);

  @override
  State<AccountDone> createState() => _AccountDoneState();
}

class _AccountDoneState extends State<AccountDone> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
                'Account Created',
                style: TextStyle(fontSize: 37),
              ),
              SizedBox(
                child: Icon(
                  Icons.thumb_up_alt_rounded,
                  size: screenheight / 2.5,
                ),
              ),
              SizedBox(
                height: screenheight / 10,
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Colors.white,
                  child: Text(
                    "LOG IN",
                    style: TextStyle(fontSize: 20),
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
