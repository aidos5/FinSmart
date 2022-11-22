import 'package:flutter/material.dart';
import 'package:hecker/UI/Colors.dart';
import 'package:hecker/UI/app_fonts.dart';
import 'PersonalDetails.dart';
import 'Model/UserCredential.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pinput/pinput.dart';
import 'package:dbcrypt/dbcrypt.dart';

class Password extends StatefulWidget {
  Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
        child: SizedBox(
          width: screenwidth,
          height: screenheight,
          child: Column(
            children: [
              const Text(
                'Set Password',
                style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.gilroy),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.lock_outline,
                  size: screenheight / 2.5,
                ),
              ),
              Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
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
                      onCompleted: (value) {
                        password.text = value;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Text(
                        "Confirm PIN",
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
                      onCompleted: (value) {
                        confirmpassword.text = value;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                child: SizedBox(
                  height: screenheight / 15,
                  width: screenwidth / 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (password.text == confirmpassword.text) {
                        var passHash = new DBCrypt()
                            .hashpw(password.text, new DBCrypt().gensalt());

                        print(passHash);

                        userCred!.passHash = passHash;

                        await localStorage.setItem('user', userCred);

                        print(await localStorage.getItem('user'));

                        //print("successful");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => PersonalDetails()),
                            (route) => false);

                        return;
                      } else {
                        print("UnSuccessfull");
                      }
                    },
                    child: Text("Submit"),
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
