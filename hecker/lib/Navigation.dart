import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/Items.dart';
import 'package:hecker/main.dart';
import 'UI/LoginPage.dart';
import 'UI/BuyStuff/BuyStuff.dart';

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  List<IconData> NIcons = [
    Icons.add,
    Icons.analytics_outlined,
    Icons.settings,
    Icons.shopping_bag,
    Icons.logout,
    Icons.info
  ];
  List<String> NTitle = [
    'Add Products',
    'Analytics',
    'Settings',
    'Buy Stuff',
    'Log Out',
    'Info'
  ];
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Drawer(
      width: screenwidth / 1.6,
      child: Material(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 35,
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text(
                'Add Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Items()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_rounded),
              title: const Text(
                'Analytics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text(
                'Buy Stuff',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => BuyStuff()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: screenheight / 1.95,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'LogOut',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text(
                'About Us',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
