import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/Navigation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/Bill.dart';
import 'Model/ModelItem.dart';
import 'package:localstorage/localstorage.dart';
import 'package:base_x/base_x.dart';

import 'Model/ShopDetail.dart';
import 'Model/lastBillDate.dart';
import 'package:intl/intl.dart';
//import 'package:sample/Model/ModelItem.dart';

Future main() async {
  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: HexColor('#4cbfa6'),
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 37),
            ),
          ),
          scaffoldBackgroundColor: HexColor('#f6ebf4'),
          textTheme: GoogleFonts.poppinsTextTheme()),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int maxBillCount = 5;
  bool firstopen = false;
  Stream<List<ModelItem>> dataItems = readItem();

  List<TextEditingController> quantityEditor = [];

  final localStorage = LocalStorage('lastBillDate.json');
  var storage = LocalStorage('shopDetail.json');

  List<int> count = [];

  List<Widget> tabs = [];
  List<Widget> billtabs = [];

  List<ModelItem> allItems = [];
  List<ModelItem> foundItems = [];
  List<ModelItem> billedItems = [];
  List<Map<String, dynamic>> billJson = [];
  String billNo = '';

  int totalCost = 0;

  String shopID = '12345678910';
  var base62 = BaseXCodec(
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');

  lastBillDate? lBD;

  //List<Bill> bills = [];

  @override
  void initState() {
    fillItems();
    getDate();
    super.initState();
  }

  void fillItems() async {
    dataItems.listen(
      (listofitems) {
        for (ModelItem i in listofitems) {
          allItems.add(i);
        }
        
        setState(() {
          foundItems = List.from(allItems);
        });
      },
    );
  }

  void getDate() async {
    var l = await localStorage.getItem('lastBillDate');
    if (l == null) {
      await localStorage.setItem('lastBillDate', new lastBillDate());
    }

    lBD = await lastBillDate.fromJson(localStorage.getItem('lastBillDate'));
    print(lBD!.lastBill);
    print(lBD!.toJson());

    // shopID = ShopDetail.fromJson(await storage.getItem('shop')).id as String;
    // print(shopID);
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: maxBillCount,
      child: Scaffold(
          drawer: Navigation(),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'FinSmart',
              style: TextStyle(fontSize: 37),
            ),
            backgroundColor: HexColor('#4cbfa6'),
            bottom: TabBar(
              tabs: allTabs(),
              isScrollable: true,
            ),
          ),
          body: TabBarView(children: BillView())),
    );
  }

  List<Widget> allTabs() {
    tabs = [];
    for (int i = 1; i <= maxBillCount; i++) {
      tabs.add(
        Tab(
          child: Text(
            '$i',
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    }
    return tabs;
  }

  List<Widget> BillView() {
    final screenwidth = MediaQuery.of(context).size.width;

    billtabs = [];
    print(foundItems.length);
    for (int i = 1; i <= maxBillCount; i++) {
      billtabs.add(
        Tab(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenwidth,
                  child: StreamBuilder<List<ModelItem>>(
                    stream: dataItems,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('There is an error ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search Item',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                              ),
                              onChanged: searchItems,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: foundItems.length,
                              itemBuilder: (context, index) => cardmaker(index),
                              physics: AlwaysScrollableScrollPhysics(),
                            ),
                            MaterialButton(
                              onPressed: (() {
                                generateBill();
                              }),
                              child: Text('Checkout'),
                              color: Colors.amber,
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return billtabs;
  }

  Card cardmaker(int index) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Name : ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${foundItems[index].name}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                'Quantity left: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${foundItems[index].quantity} ',
                style: TextStyle(fontSize: 20),
              ),
              Text('${foundItems[index].unit}', style: TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            children: [
              Text(
                'Selling Price : ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${foundItems[index].rate}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          quantityField(index),
        ],
      ),
    );
  }

  Widget quantityField(int index) {
    count.add(0);
    quantityEditor.add(TextEditingController());
    quantityEditor[index].text = count[index].toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 192, 178, 178),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(
                    () {
                      if (count[index] == 0) {
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: const Center(
                              child: Text(
                                'No Negatives',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ));
                      } else {
                        setState(
                          () {
                            count[index]--;
                            // quantityEditor[index].text = count[index].toString();
                            quantityEditor[index].value = TextEditingValue(
                              text: count[index].toString(),
                              selection: TextSelection.collapsed(
                                offset: 0,
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  //initialValue: '${count[index]}',
                  onChanged: (value) {
                    if (value.isNotEmpty) count[index] = int.parse(value);
                  },
                  controller: quantityEditor[index],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(
                    () {
                      count[index]++;
                      quantityEditor[index].value = TextEditingValue(
                        text: count[index].toString(),
                        selection: TextSelection.collapsed(
                          offset: 0,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future generateBill() async {
    String tempIter = '';
    int temp;

    if (lBD!.lastBill == null) {
      lBD!.lastBill = DateFormat.yMd().format(DateTime.now());
      lBD!.lastBill = lBD!.lastBill!.replaceAll(new RegExp(r'[^\w\s]+'), '');
      lBD!.iterator = '000001';

      await localStorage.setItem('lastBillDate', lBD);

      print(await localStorage.getItem('lastBillDate'));
    } else if (lBD!.lastBill != DateFormat.yMd().format(DateTime.now())) {
      lBD!.lastBill = DateFormat.yMd().format(DateTime.now());
      lBD!.lastBill != lBD!.lastBill!.replaceAll(new RegExp(r'[^\w\s]+'), '');

      await localStorage.setItem('lastBillDate', lBD);
    } else {
      temp = int.parse(lBD!.iterator as String);
      temp++;

      for (int i = 0; i < 6 - temp.toString().length; i++) {
        tempIter = tempIter + '0';
      }

      tempIter = tempIter + temp.toString();
      lBD!.iterator = tempIter;
      await localStorage.setItem('lastBillDate', lBD);

      print(await localStorage.getItem('lastBillDate'));
    }

    var billN = ('$shopID${lBD!.lastBill}${lBD!.iterator}');
    print(billN);

    var encoded = base64.encode([
      int.parse(shopID),
      int.parse(lBD!.lastBill!),
      int.parse(lBD!.iterator!)
    ]);

    var hash = Uint8List.fromList([
      int.parse(shopID),
      int.parse(lBD!.lastBill!),
      int.parse(lBD!.iterator!)
    ]);

    billNo = base62.encode(hash);
    billJson.add({});
    totalCost = 0;
    for (var i = 0; i < foundItems.length; i++) {
      if (count[i] != 0) {
        billedItems = List.from(foundItems);
        billJson[i] = billedItems[i].toJson();
        totalCost += billedItems[i].rate * count[i];
      }
    }

    final bill = Bill(
        shopName: 'shopName',
        shopAddress: 'shopAddress',
        GSTNumber: 'GSTNumber',
        billJson: billJson,
        totalCost: totalCost,
        billNumber: billNo,
        paymentMode: 'paymentMode',
        customerName: 'customerName',
        customerNumber: 'customerNumber');

    //print(bill.totalCost);

    final doc = bill.toJson();
    final docuser = FirebaseFirestore.instance
        .collection('transactions')
        .doc('category')
        .collection('pincode')
        .doc('shopid')
        .collection('bills')
        .doc('day2');

    await docuser.set(doc);
  }

  void searchItems(String query) {
    List<ModelItem> results = [];
    if (query.isEmpty && query != null) {
      results.addAll(allItems);
    } else {
      results = allItems.where((item) {
        final itemName = item.name.toLowerCase();
        query = query.toLowerCase();
        return itemName.contains(query);
      }).toList();
    }

    setState(() {
      foundItems = List.from(results);
    });
  }

  static Stream<List<ModelItem>> readItem() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .doc('category')
        .collection('pincode')
        .doc('shopid')
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ModelItem.fromJson(doc.data()))
            .toList());
  }
}
