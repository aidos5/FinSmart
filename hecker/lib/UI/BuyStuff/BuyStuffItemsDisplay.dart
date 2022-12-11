import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hecker/Model/Bill.dart';
import 'package:hecker/Model/BillItem.dart';
import 'package:hecker/Model/ModelItem.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/UI/BuyStuff/BuyStuffCart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../Navigation.dart';
import '../Colors.dart';

class BuyStuffItemsDisplay extends StatefulWidget {
  BuyStuffItemsDisplay({Key? key}) : super(key: key);

  ShopDetail? shopDetail;
  BuyStuffItemsDisplay.load({required this.shopDetail});

  @override
  State<BuyStuffItemsDisplay> createState() =>
      _BuyStuffItemsDisplayState(shopDetail: shopDetail);
}

class _BuyStuffItemsDisplayState extends State<BuyStuffItemsDisplay> {
  TextEditingController searchController = TextEditingController();
  bool isInit = false;

  List<BillItem>? allItems;
  List<BillItem>? displayItems = [];
  int count = 0;

  Bill? bill;

  ShopDetail? shopDetail;

  _BuyStuffItemsDisplayState({required this.shopDetail});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialize();
  }

  void initialize() async {
    await loadItems();

    setState(() {
      isInit = true;
    });
  }

  Future loadItems() async {
    allItems = (await loadItemsFromDB())
        .map((e) => BillItem(item: e, quantity: 0, totalAmount: 0))
        .toList();
    displayItems = allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FinSmart",
          style: TextStyle(fontSize: 37),
        ),
      ),
      drawer: Navigation(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Item',
              ),
              onChanged: (value) {
                searchItem(value);
              },
            ),
          ),

          // Display shops here
          Expanded(
            child: isInit
                ? ListView.builder(
                    itemCount: displayItems!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return item(displayItems![index]);
                    },
                  )
                : Center(
                    child: Text("Loading..."),
                  ),
          )
        ],
      ),
      floatingActionButton: (count > 0)
          ? SizedBox(
              width: 100,
              child: FloatingActionButton(
                shape: BeveledRectangleBorder(),
                onPressed: (() async {
                  await generateBill();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => BuyStuffCart(
                        shopDetail: shopDetail,
                        bill: bill,
                      )),
                      (route) => false);
                }),
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            )
          : null,
    );
  }

  Card item(BillItem item) {

    List<Color> cardColor = [
      AppColors.blueCard,
      AppColors.pinkCard,
      AppColors.orangeCard
    ];
    return Card(
      color: cardColor[0],
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Name : ${item.item.name}',
                style: TextStyle(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                width: 25,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Selling Price : ${item.item.rate}',
                style: TextStyle(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          quantityField(item),
        ],
      ),
    );
  }

  Widget quantityField(BillItem item) {
    final screenheight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              MaterialButton(
                color: HexColor('#b2b2b2'),
                shape: CircleBorder(),
                child: const Icon(Icons.remove),
                onPressed: () {
                  setState(
                    () {
                      if (item.quantity == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                            content: Container(
                              padding: const EdgeInsets.all(8),
                              height: screenheight / 17.5,
                              width: 500,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: const Center(
                                child: Text(
                                  'No Negatives',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        setState(
                          () {
                            count--;
                            item.quantity--;
                            // quantityEditor[index].text = count[index].toString();
                            item.quantityEditor.value = TextEditingValue(
                              text: item.quantity.toString(),
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
                    if (value.isNotEmpty) item.quantity = double.parse(value);
                  },
                  controller: item.quantityEditor,
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
              MaterialButton(
                color: HexColor('#b2b2b2'),
                shape: CircleBorder(),
                child: const Icon(Icons.add),
                onPressed: () {
                  setState(
                    () {
                      count++;
                      item.quantity++;
                      item.quantityEditor.value = TextEditingValue(
                        text: item.quantity.toString(),
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

    List<BillItem> items = [];

    for (int i = 0; i < displayItems!.length; i++) {
      if (displayItems![i].quantity > 0) {
        displayItems![i].totalAmount =
            displayItems![i].item.rate * displayItems![i].quantity;
        items.add(displayItems![i]);
      }
    }

    double totalCost = 0;
    for (var i in items) {
      totalCost += i.totalAmount;
    }

    ShopDetail? myShopDet =
        ShopDetail.fromJson((await LocalStorage('shopDetail.json').getItem('shop')) as Map<String, dynamic>);

    bill = Bill(
        billID: "",
        items: items,
        paymentMode: "",
        dateTime: DateTime.now(),
        totalAmount: totalCost,
        customerName: myShopDet.name!,
        customerNumber: myShopDet.contactNumber!,
        customerAddress: myShopDet.address!,
        customerGSTN: myShopDet.gstn!);
  }

  void searchItem(String val) {
    setState(() {
      displayItems = allItems!
          .where((element) =>
              element.item.name.toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  Future<List<ModelItem>> loadItemsFromDB() async {
    var itemDocs = await FirebaseFirestore.instance
        .collection('transactions')
        .doc('category')
        .collection('pincode')
        .doc('shopid')
        .collection('items')
        .get();

    var items = itemDocs.docs.map((e) => ModelItem.fromJson(e.data())).toList();

    return items;
  }
}
