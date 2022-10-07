import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/Navigation.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: (() {Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddItems()),
                    (route) => false);}),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('FinSmart')),
      drawer: Navigation(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: screenwidth,
          height: screenheight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
