import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Drawer(
      width: screenwidth / 1.6,
      child: Material(
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, int index) => Nav(
            index,
          ),
        ),
      ),
    );
  }

  Nav(int index) {
    return ListTile(
      title: Text('${index}'),
    );
  }
}
