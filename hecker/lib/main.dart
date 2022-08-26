import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passwordfield/passwordfield.dart';
import 'Signup.dart';

void main() {
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
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

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
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontSize: 37),
          ),
        ),
        backgroundColor: HexColor('#4cbfa6'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: screenwidth,
          height: screenheight,
          color: HexColor('#f6ebf4'),
          child: Column(
            children: [
              Text(
                'Shop Name',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 37),
                ),
              ),
              SizedBox(
                width: screenwidth / 1.5,
                child: TextField(
                  showCursor: true,
                  controller: NameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                    labelStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 17),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 3,
                        color: HexColor('#482673'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenheight / 20,
              ),
              Text(
                'Enter Password',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 37),
                ),
              ),
              SizedBox(
                width: screenwidth / 1.5,
                child: PasswordField(
                  controller: PasswordController,
                  backgroundColor: HexColor('#f6ebf4').withOpacity(0.5),
                  errorMessage: 'Enter Password Please',
                  passwordConstraint: '[]{0}',
                  hintText: 'Enter Password',
                  inputDecoration: PasswordDecoration(
                      inputPadding: const EdgeInsets.symmetric(horizontal: 20),
                      hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 17),
                      )),
                  border: PasswordBorder(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: screenwidth / 15,
                            color: HexColor('#482673')),
                        borderRadius: BorderRadius.circular(17)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3.5, color: HexColor('#482673')),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3.5, color: HexColor('#482673')),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: (() {}),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    HexColor('#ed0b70'),
                  )),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Not Registered?',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              TextButton(
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        decoration: (TextDecoration.underline),
                      ),
                    ),
                  ),
                  onPressed: (() {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Signup()),
                        (route) => false);
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
