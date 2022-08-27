import 'package:flutter/material.dart';
import 'package:hecker/ShopDetails.dart';

class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<String> Genders = ['Select Gender', 'Male', 'Female', 'I am Gay'];
  String? selectedGender = 'Select Gender';
  DateTime? dateTime = DateTime.now();
  DateTime? newDate;

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
                'Enter Personal Details',
                style: TextStyle(fontSize: 37),
              ),
              Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Your Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Enter Your Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 18,
                          left: screenwidth / 4,
                          right: screenwidth / 4),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: selectedGender,
                        items: Genders.map(
                          ((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                        ).toList(),
                        onChanged: (item) =>
                            setState(() => selectedGender = item),
                        validator: (value) {
                          if (value != null && value == 'Select Gender') {
                            return 'Enter Your Gender';
                          } else
                            return null;
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          children: [
                            Text(
                              'Enter your Date Of Birth',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                newDate = await showDatePicker(
                                    context: context,
                                    initialDate: dateTime!,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2200));

                                if (newDate == null)
                                  return;
                                else {
                                  setState(() => dateTime = newDate);
                                }
                              },
                              child: Text('${dateTime!.day}/'
                                  '${dateTime!.month}/'
                                  '${dateTime!.year}'),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenheight / 15,
                      child: RaisedButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            //print("successful");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ShopDetails()),
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
