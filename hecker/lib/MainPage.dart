import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/Model/BillItem.dart';
import 'package:hecker/Model/TabClass.dart';
import 'package:hecker/Navigation.dart';
import 'package:hecker/Number.dart';
import 'package:hecker/Payments.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  var localStorageShop = LocalStorage('shopDetail.json');
  var localStorageItems = LocalStorage('items.json');

  List<Widget> tabs = [];
  List<Tab> displayTabs = [];

  List<ModelItem> allItems = [];
  List<Map<String, dynamic>> billJson = [];
  String billNo = '';

  int totalCost = 0;

  ShopDetail? shopDetail;
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

  Future LoadShopDetail() async {
    var shopJSON = await localStorageShop.getItem('shop');
    shopDetail = ShopDetail.fromJson((shopJSON as Map<String, dynamic>));
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
        tC[i].allItems = List.from(allItems);
        tC[i].foundItems = List.from(allItems);
        tC[i].quantityEditor = [];
        tC[i].count = [];
        tC[i].showPaymentView = false;
        for (int j = 0; j < allItems.length; j++) {
          tC[i].quantityEditor!.add(new TextEditingController());
          tC[i].count!.add(0);
        }
      }
    });

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
            floatingActionButton: (tC[currentTabIndex].count!.sum > 0 && tC[currentTabIndex].showPaymentView! != true)
                ? SizedBox(
                    width: 100,
                    child: FloatingActionButton(
                      shape: BeveledRectangleBorder(),
                      onPressed: (() {
                        generateBill();
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(builder: (context) => Payments()),
                        //     (route) => false);
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
            body: TabBarView(controller: tabController, children: BillView()));
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
          child: tC[i].showPaymentView! == false
              ? TabView(i, screenwidth)
              : PaymentView(tC[i].bill!));

      displayTabs.add(tC[i].billtabs!);
    }

    return displayTabs;
  }

  Widget TabView(int i, double screenWidth) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
        width: screenWidth,
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
      ),
    ]);
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
    var formatter = new DateFormat('ddMMyyyy');
    String date = formatter.format(DateTime.now());
    // String date =
    //     DateFormat(DateTime.now()).toString().replaceAll(RegExp("/"), '');

    if (shopDetail == null) {
      // Show error
      await LoadShopDetail();
    }

    String? lastBillDate = await localStoragebillDate.getItem('lastBilldate');
    if (lastBillDate == null) {
      await localStoragebillDate.setItem('lastBillDate', date);
      lastBillDate = date;
    }

    var billC = await localStoragebillDate.getItem('billCount');
    if (billC == null || lastBillDate != date) {
      await localStoragebillDate.setItem('billCount', '0');
      billC = '0';
    }
    int billCount = int.parse(billC.toString());
    billCount++;
    await localStoragebillDate.setItem('billCount', billCount.toString());

    //{payment mode}{shop id}{date}{bill count of that day}
    String billNumber = "11${shopDetail!.id}${date}${billCount}";
    String billID = GetBillID(BigInt.parse(billNumber));

    List<BillItem> items = [];
    TabClass curTab = tC[currentTabIndex];

    for (int i = 0; i < curTab.count!.length; i++) {
      if (curTab.count![i] != 0) {
        items.add(new BillItem(
            item: curTab.allItems![i],
            quantity: curTab.count![i].toDouble(),
            totalAmount:
                curTab.allItems![i].rate * curTab.count![i].toDouble()));
      }
    }

    double totalCost = 0;
    for (var i in items) {
      totalCost += i.totalAmount;
    }

    Bill bill = Bill(
        billID: billID,
        items: items,
        paymentMode: "UPI",
        dateTime: DateTime.now(),
        totalAmount: totalCost,
        customerName: "customerName",
        customerNumber: "customerNumber",
        customerAddress: "customerAddress",
        customerGSTN: "customerGSTN");

    //print(bill.totalCost);

    var billJSON = bill.toJson(); //bill.toJson().toString();
    print("Bill : " + billJSON.toString());
    final docuser = FirebaseFirestore.instance
        .collection('transactions')
        .doc('category')
        .collection('pincode')
        .doc('shopid')
        .collection('bills')
        .doc('offlineBills')
        .collection("day2")
        .doc("part1");

    List<dynamic> billArr = [];
    billArr.add(billJSON);

    // Store it in local storage
    await docuser.set({'bills': FieldValue.arrayUnion(billArr)}, SetOptions(merge: true));

    setState(() {
      tC[currentTabIndex].bill = bill;
      tC[currentTabIndex].showPaymentView = true;
    });
  }

  Widget PaymentView(Bill bill) {
    return Column(
      children: [
        QrImage(
            size: 320,
            data:
                "upi://pay?pa=${shopDetail!.upiVPA}&pn=${shopDetail!.name}&am=${bill.totalAmount}&cu=INR&tr=${bill.billID}&tn=Paying for order : ${bill.billID}"),

        ElevatedButton(onPressed: () {
          setState(() {
            tC[currentTabIndex].showPaymentView = false;
          });
        }, child: Text("Back"))
      ],
    );
  }

  String GetBillID(BigInt n) {
    String characterSet =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    BigInt zero = BigInt.from(0);
    BigInt six2 = BigInt.from(62);
    BigInt r;

    String billID = "";
    while (n > zero) {
      r = n % six2;
      n ~/= six2;
      billID = characterSet[r.toInt()] + billID;
    }

    return billID;
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
