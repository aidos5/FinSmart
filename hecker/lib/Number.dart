import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecker/OTP.dart';
import 'main.dart';
class Number extends StatefulWidget {
  const Number();

  @override
  State<Number> createState() => _NumberState();
}

class _NumberState extends State<Number> {
  final TextEditingController mobileNumber = TextEditingController();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Your Mobile Number',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                child: Icon(
                  Icons.phone_android,
                  size: screenheight / 2.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mobileNumber,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      labelText: 'Enter number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value != null && value.length < 10) {
                      return 'Enter Mobile number';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: screenheight / 15,
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    if (mobileNumber.text.length == 10) {
                      //print("successful");
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => OTP()),
                      //     (route) => false);

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Would you like to confirm'),
                              Text(
                                '${mobileNumber.text}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('as your Number??'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const Text('NO'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => OTP()),
                                    (route) => false);
                              },
                              child: const Text('YES'),
                            ),
                          ],
                        ),
                      );
                      const Text('Show Dialog');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        content: Container(
                          padding: const EdgeInsets.all(8),
                          height: screenheight / 15,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Center(
                            child: Text(
                              'Please enter correct Phone Number',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ));
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
      ),
    );
  }
}
