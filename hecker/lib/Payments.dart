import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
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
                'Choose Payment Methods',
                style: TextStyle(fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'UPI',
                    style: TextStyle(fontSize: 30),
                  ),
                  onPressed: (() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'Cards',
                    style: TextStyle(fontSize: 30),
                  ),
                  onPressed: (() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'Cash',
                    style: TextStyle(fontSize: 30),
                  ),
                  onPressed: (() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'Others',
                    style: TextStyle(fontSize: 30),
                  ),
                  onPressed: (() {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
