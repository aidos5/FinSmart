import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecker/AccountDone.dart';

class ShopDetails extends StatefulWidget {
  ShopDetails({Key? key}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
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
                'Enter Shop Details',
                style: TextStyle(fontSize: 37),
              ),
              Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Shop Name',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter Your Shop Name';
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
                            labelText: "Enter Area PIN",
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value != null && value.length < 6) {
                            return 'Enter PIN';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 5,
                        decoration: const InputDecoration(
                            labelText: 'Shop Address',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter Shop Address';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenheight / 15,
                      child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            //print("successful");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AccountDone()),
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
