import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hecker/Model/UserCredential.dart';
import 'package:hecker/ShopDetails.dart';

import 'package:localstorage/localstorage.dart';

class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<String> Genders = ['Select Gender', 'Male', 'Female', 'I am Gay'];
  String? selectedGender = 'Select Gender';
  DateTime? dob = DateTime.now();
  DateTime? newDate;
  bool? isOwner = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

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
                      controller: nameController,
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
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: addressController,
                      decoration: const InputDecoration(
                          labelText: 'Your Address',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Enter Your Address';
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
                            MaterialButton(
                              onPressed: () async {
                                newDate = await showDatePicker(
                                    context: context,
                                    initialDate: dob!,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2200));

                                if (newDate == null)
                                  return;
                                else {
                                  setState(() => dob = newDate);
                                }
                              },
                              child: Text('${dob!.day}/'
                                  '${dob!.month}/'
                                  '${dob!.year}'),
                            )
                          ],
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: Text("Regester as Owner"),
                        value: isOwner,
                        onChanged: (value) {
                          setState(() {
                            isOwner = value;
                          });
                        }),
                    SizedBox(
                      height: screenheight / 15,
                      child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            //print("successful");

                            // Set basic details
                            userCred!.name = nameController.text;
                            userCred!.gender = selectedGender!;
                            userCred!.dob =
                                '${dob!.day}/${dob!.month}/${dob!.year}';
                            userCred!.regDate = DateTime.now().toString();
                            userCred!.isOwner = isOwner;
                            userCred!.address = addressController.text;

                            // If owner set shop id
                            if (isOwner!) {
                              String? id =
                                  (int.tryParse(userCred!.phoneNo!)! * 37)
                                      .toString();

                              int iterCount = 12 - id.length;
                              for (int i = 0; i < iterCount; i++) {
                                id = "0" + id!;
                              }

                              userCred!.shopID = id!;
                            }

                            // Store User Creds
                            await localStorage.setItem('user', userCred);

                            print(await localStorage.getItem('user'));

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
