import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/MainPage.dart';
import 'package:hecker/UI/LoginPIN.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';
import 'package:passwordfield/passwordfield.dart';
import 'Model/UserCredential.dart';
import 'Number.dart';
import 'UI/LoginPage.dart';
import 'UI/Passcode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

    userCred =
        await UserCredential.fromJson(await localStorage.getItem('user'));

    print(userCred?.toJson());
    setState(() {
      isInit = true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: HexColor('#4cbfa6'),
              centerTitle: true,
              titleTextStyle: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 37),
              ),
            ),
            scaffoldBackgroundColor: HexColor('#f6ebf4'),
            textTheme: GoogleFonts.poppinsTextTheme()),
        home: isInit
            ? showLoginPage()
            : Container(
                child: Text("Loading..."),
              ));
  }

  showLoginPage() {
    if (userCred!.passHash.isEmpty) {
      return LoginPage();
    } else {
      return LoginPIN();
    }
  }
}
