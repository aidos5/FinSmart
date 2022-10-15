import 'package:flutter/material.dart';
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
              Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text("Enter PIN"),
                    Pinput(
                      length: 6,
                      obscureText: true,
                      onCompleted: (value) {
                        password.text = value;
                      },
                    ),
                    Text("Confirm PIN"),
                    Pinput(
                      length: 6,
                      obscureText: true,
                      onCompleted: (value) {
                        confirmpassword.text = value;
                      },
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8),
                    //   child: TextFormField(
                    //     controller: password,
                    //     decoration: const InputDecoration(
                    //         labelText: 'Set Password',
                    //         border: OutlineInputBorder()),
                    //     keyboardType: TextInputType.text,
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Please a Enter Password';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextFormField(
                    //     controller: confirmpassword,
                    //     decoration: const InputDecoration(
                    //         labelText: 'Confirm Password',
                    //         border: OutlineInputBorder()),
                    //     obscureText: true,
                    //     keyboardType: TextInputType.text,
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Please re-enter password';
                    //       }

                    //       if (password.text != confirmpassword.text) {
                    //         return "Password does not match";
                    //       }

                    //       return null;
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: screenheight / 15,
                      child: MaterialButton(
                        color: Colors.redAccent,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        textColor: Colors.white,
                        child: Text("Submit"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
