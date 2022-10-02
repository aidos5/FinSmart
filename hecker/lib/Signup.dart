import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class Signup extends StatefulWidget {
  const Signup();

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String dropdownValue = 'General Stores';
  List<String> Stores = ['General Stores', 'Hotel', 'Bakery', 'Stationary'];
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
      body: Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                  labelText: 'Shop Name', border: OutlineInputBorder()),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Enter Shop Name';
                } else {
                  return null;
                }
              },
            ),
            Center(
              child: Text(
                'Choose Shop Category',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Center(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 15),
                  color: Colors.black,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: Stores.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: const InputDecoration(
                    labelText: 'Shop Address', border: OutlineInputBorder()),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Enter Shop Address';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 6,
                decoration: const InputDecoration(
                    labelText: "Enter Area PIN", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Enter PIN';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: password,
                decoration: const InputDecoration(
                    labelText: 'Set Password', border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please a Enter Password';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: confirmpassword,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder()),
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please re-enter password';
                  }

                  if (password.text != confirmpassword.text) {
                    return "Password does not match";
                  }

                  return null;
                },
              ),
            ),
            SizedBox(
              height: screenheight / 15,
              child: MaterialButton(
                
                color: Colors.redAccent,
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    //print("successful");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
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
    );
  }
}
