import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/MainPage.dart';
import 'package:hecker/UI/LoginPIN.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';
import 'package:passwordfield/passwordfield.dart';
import 'Model/UserCredential.dart';
import 'Number.dart';
import 'UI/Colors.dart';
import 'UI/LoginPage.dart';
import 'UI/Passcode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'UI/app_fonts.dart';
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

    super.initState();
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
        fontFamily: AppFonts.gilroy,
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontSizeFactor: 1.0, fontFamily: AppFonts.lato),
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.white,
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(12.0),
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, 10),
              textStyle: TextStyle(fontFamily: AppFonts.lato)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 10,
          iconTheme: IconThemeData(color: AppColors.textColor),
          titleTextStyle: TextStyle(
            color: AppColors.textColor,
            fontFamily: AppFonts.lato,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
      ),
      home: isInit
          ? showLoginPage()
          : Container(
              child: Text("Loading..."),
            ),
    );
  }

  showLoginPage() {
    if (userCred!.passHash.isEmpty) {
      return LoginPage();
    } else {
      return LoginPIN();
    }
  }
}
