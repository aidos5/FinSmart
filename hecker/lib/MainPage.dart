import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/Model/TabClass.dart';
import 'package:hecker/Navigation.dart';
import 'package:hecker/Payments.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/Bill.dart';
import 'Model/ModelItem.dart';
import 'package:localstorage/localstorage.dart';
import 'package:base_x/base_x.dart';

import 'Model/ShopDetail.dart';
import 'Model/lastBillDate.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int maxBillCount = 5;
  bool firstopen = false;
  List<TabClass> tC = [];
  int currentTabIndex = 0;

  final localStoragebillDate = LocalStorage('lastBillDate.json');
  var storage = LocalStorage('shopDetail.json');
  var localStorageItems = LocalStorage('items.json');

  List<Widget> tabs = [];
  List<Tab> displayTabs = [];

  List<ModelItem> allItems = [];
  List<Map<String, dynamic>> billJson = [];
  String billNo = '';

  int totalCost = 0;

  String shopID = '12345678910';
  var base62 = BaseXCodec(
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');

  lastBillDate? lBD;

  //List<Bill> bills = [];

  List<bool> hasCheckout = [];
  TabController? tabController;

  bool isInit = false;

  @override
  void initState() {
    print("Lowde");
    LoadItems();

    tabController = new TabController(length: maxBillCount, vsync: this);
    tabController!.addListener(() {
      setState(() {
        currentTabIndex = tabController!.index;
      });
    });
    getDate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController!.dispose();
    super.dispose();
  }

  Future LoadItems() async {
    // setState(() {
    //   for (int i = 0; i < maxBillCount; i++) {
    //     tC.add(TabClass(
    //         billtabs: Tab(
    //       text: "Loading...",
    //     )));
    //   }
    // });

    var temp = await (localStorageItems.getItem('items'));
    if (temp != null) {
      List allItemString = (jsonDecode(temp) as List<dynamic>);

      for (dynamic s in allItemString) {
        allItems.add(ModelItem.fromJson(jsonDecode(s)));
      }
    }

    setState(() {
      for (int i = 0; i < maxBillCount; i++) {
        tC.add(TabClass());
        tC[i].foundItems = List.from(allItems);
        tC[i].quantityEditor = [];
        tC[i].count = [];
        for (int j = 0; j < allItems.length; j++) {
          tC[i].quantityEditor!.add(new TextEditingController());
          tC[i].count!.add(0);
        }
      }
    });

    // if (tC[i].foundItems.length < 1) {
    //   print("lowde");
    //   FirebaseFirestore.instance
    //       .collection('transactions')
    //       .doc('category')
    //       .collection('pincode')
    //       .doc('shopid')
    //       .collection('items')
    //       .snapshots()
    //       .map((snapshot) => snapshot.docs
    //           .map((doc) => ModelItem.fromJson(doc.data()))
    //           .toList())
    //       .listen((event) {
    //     for (ModelItem mi in event) {
    //       allItems.add(mi);
    //     }

    //     tC[i].foundItems = List.from(allItems);
    //   });
    // }

    print("Lowde : " + tC.length.toString());

    isInit = true;
  }

  void getDate() async {
    var l = await localStoragebillDate.getItem('lastBillDate');
    if (l == null) {
      await localStoragebillDate.setItem('lastBillDate', new lastBillDate());
    }

    lBD = await lastBillDate
        .fromJson(localStoragebillDate.getItem('lastBillDate'));
    print(lBD!.lastBill);
    print(lBD!.toJson());

    // shopID = ShopDetail.fromJson(await storage.getItem('shop')).id as String;
    // print(shopID);
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return !isInit
        ? Scaffold(
            appBar: AppBar(
              title: Text("Finsmart"),
            ),
            body: Center(child: Text("Loading...")),
          )
        : Scaffold(
            floatingActionButton: tC[currentTabIndex].count!.sum > 0
                ? SizedBox(
                    width: 100,
                    child: FloatingActionButton(
                      shape: BeveledRectangleBorder(),
                      onPressed: (() {
                        generateBill();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Payments()),
                            (route) => false);
                      }),
                      child: Text('Checkout'),
                    ),
                  )
                : null,
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
                controller: tabController,
              ),
            ),
            body: TabBarView(
                controller: tabController, children: BillView()));
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

    displayTabs = [];
    for (int i = 0; i < maxBillCount; i++) {
      // tC.add(TabClass());
      // setState(() {
      //   tC[i].foundItems = List.from(allItems);

      //   tC[i].quantityEditor = [];
      //   tC[i].count = [];
      //   for (int i = 0; i < allItems.length; i++) {
      //     tC[i].quantityEditor!.add(new TextEditingController());
      //     tC[i].count!.add(0);
      //   }
      // });

      tC[i].billtabs = Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              onChanged: searchItems,
            ),
            SizedBox(
              width: screenwidth,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: firstopen == true
                        ? allItems.length
                        : tC[i].foundItems!.length,
                    itemBuilder: (context, index) => cardmaker(index, i),
                    physics: AlwaysScrollableScrollPhysics(),
                  ),
                ],
              ),
            )
          ],
        ),
      );

      displayTabs.add(tC[i].billtabs!);
    }

    return displayTabs;
  }

  Card cardmaker(int index, int i) {
    return firstopen == false
        ? Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${tC[i].foundItems![index].name}',
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
                      '${tC[i].foundItems![index].quantity} ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${tC[i].foundItems![index].unit}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Selling Price : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${tC[i].foundItems![index].rate}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                quantityField(index, i),
              ],
            ),
          )
        : Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${allItems[index].name}',
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
                      '${allItems[index].quantity} ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${allItems[index].unit}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Selling Price : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${allItems[index].rate}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                quantityField(index, i),
              ],
            ),
          );
  }

  Widget quantityField(int index, int i) {
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
                      if (tC[i].count![index] == 0) {
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
                            tC[i].count![index]--;
                            // quantityEditor[index].text = count[index].toString();
                            tC[i].quantityEditor![index].value =
                                TextEditingValue(
                              text: tC[i].count![index].toString(),
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
                    if (value.isNotEmpty)
                      tC[i].count![index] = int.parse(value);
                  },
                  controller: tC[i].quantityEditor![index],
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
                      tC[i].count![index]++;
                      tC[i].quantityEditor![index].value = TextEditingValue(
                        text: tC[i].count![index].toString(),
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
    var bill;

    if (lBD!.lastBill == null) {
      lBD!.lastBill = DateFormat.yMd().format(DateTime.now());
      lBD!.lastBill = lBD!.lastBill!.replaceAll(new RegExp(r'[^\w\s]+'), '');
      lBD!.iterator = '000001';

      await localStoragebillDate.setItem('lastBillDate', lBD);

      print(await localStoragebillDate.getItem('lastBillDate'));
    } else if (lBD!.lastBill != DateFormat.yMd().format(DateTime.now())) {
      lBD!.lastBill = DateFormat.yMd().format(DateTime.now());
      lBD!.lastBill != lBD!.lastBill!.replaceAll(new RegExp(r'[^\w\s]+'), '');

      await localStoragebillDate.setItem('lastBillDate', lBD);
    } else {
      temp = int.parse(lBD!.iterator as String);
      temp++;

      for (int i = 0; i < 6 - temp.toString().length; i++) {
        tempIter = tempIter + '0';
      }

      tempIter = tempIter + temp.toString();
      lBD!.iterator = tempIter;
      await localStoragebillDate.setItem('lastBillDate', lBD);

      print(await localStoragebillDate.getItem('lastBillDate'));
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

    // for (var i = 0; i < tC[i].foundItems!.length; i++) {
    //   if (count[i] != 0) {
    //     tC[i].billedItems = List.from(tC[i].foundItems!);
    //     billJson[i] = tC[i].billedItems![i].toJson();
    //     totalCost += tC[i].billedItems![i].rate * count[i];
    //   }
    // }
    for (int i = 0; i < tC.length; i++) {
      tC[i].totalCost = 0;
      tC[i].billJson!.add({});
      for (int j = 0; j < tC[i].foundItems!.length; j++) {
        if (tC[j].count![i] != 0) {
          tC[j].billedItems = List.from(tC[i].foundItems!);
          billJson[i] = tC[j].billedItems![i].toJson();
          totalCost += tC[j].billedItems![i].rate * tC[j].count![i];
        }
      }
    }

    bill = Bill(
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
    setState(() {
      firstopen = false;
    });
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
      for (var i = 0; i < tC.length; i++) {
        tC[i].foundItems = List.from(results);
      }
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
