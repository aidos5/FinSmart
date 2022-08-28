import 'package:flutter/material.dart';
import 'package:hecker/Payments.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Navigation.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int Pages = 11;
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FinSmart',
          style: TextStyle(fontSize: 37),
        ),
        backgroundColor: HexColor('#4cbfa6'),
      ),
      drawer: Navigation(),
      body: Container(
        width: screenwidth,
        child: Column(
          children: [
            SizedBox(
              height: screenheight / 8.4,
              child: ListView.builder(
                itemCount: Pages,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => BillCount(
                  itemNo: index,
                ),
              ),
            ),
            SizedBox(
              width: screenwidth,
              height: screenheight / 1.5,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) => Bill(itemNo: index),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: (() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Payments()),
                    (route) => false);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Bill({required int itemNo}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 65,
        color: Colors.blue,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                'Item ${itemNo + 1}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CounterBar(),
          ],
        ),
      ),
    );
  }

  BillCount({required int itemNo}) {
    if (itemNo + 1 != Pages) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 60,
          child: ListTile(
            title: Text(
              '${itemNo + 1}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            tileColor: Colors.amber,
            onTap: () {},
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 60,
          child: ListTile(
            title: Icon(Icons.add_box),
            tileColor: Colors.amber,
            onTap: () {
              setState(() {
                Pages++;
              });
            },
          ),
        ),
      );
    }
  }
}

class CounterBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CounterState();
  }
}

class _CounterState extends State<CounterBar> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 192, 178, 178),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (count == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        content: Container(
                          padding: const EdgeInsets.all(8),
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Center(
                            child: Text(
                              'No Negatives',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ));
                    } else
                      count--;
                  });
                },
              ),
              Text(count.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(
                    () {
                      count++;
                    },
                  );
                },
              ),
            ])),
      ],
    );
  }
}
