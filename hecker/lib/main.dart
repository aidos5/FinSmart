import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/MainPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passwordfield/passwordfield.dart';
import 'Number.dart';
import 'UI/LoginPage.dart';
import 'UI/Passcode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: LoginPage(),
    );
  }
}
