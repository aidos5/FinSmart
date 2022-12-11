import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/Model/Bill.dart';
import 'package:hecker/Model/BillItem.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/UI/Payments/UPI.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Navigation.dart';
import '../Colors.dart';

class BuyStuffCart extends StatefulWidget {
  BuyStuffCart({required this.shopDetail, required this.bill, Key? key}) : super(key: key);

  ShopDetail? shopDetail;
  Bill? bill;

  @override
  State<BuyStuffCart> createState() =>
      _BuyStuffCartState(shopDetail: shopDetail, bill: bill);
}

class _BuyStuffCartState extends State<BuyStuffCart> {
  TextEditingController searchController = TextEditingController();
  bool isInit = false;

  Bill? bill;
  ShopDetail? shopDetail;

  _BuyStuffCartState({required this.shopDetail, required this.bill});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
          // Display shops here
          Expanded(
            child: isInit
                ? ListView.builder(
                    itemCount: bill!.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return item(bill!.items[index]);
                    },
                  )
                : Center(
                    child: Text("Loading..."),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 100,
              width: double.maxFinite,
              decoration: BoxDecoration(

                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Choose Payment Mode",
                    style: TextStyle(fontSize: 20),),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => UPI(
                            bill: bill,
                            shopDetail: shopDetail,
                          )),
                          (route) => false);

                        }, 
                        child: Text("UPI", style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        ),
                      ),
                      TextButton(onPressed: () {

                        }, 
                        child: Text("Card", style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        ),
                      ),
                      TextButton(onPressed: () {

                        }, 
                        child: Text("Cash", style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card item(BillItem item) {
    // final screenwidth = MediaQuery.of(context).size.width;

    List<Color> cardColor = [
      AppColors.blueCard,
      AppColors.pinkCard,
      AppColors.orangeCard
    ];
    // Color appliedColor = cardColor[Random().nextInt(3)];
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
            ],
          ),
          Row(
            children: [
              Text(
                'Rate : ${item.item.rate}',
                style: TextStyle(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Quantity : ${item.item.quantity}',
                style: TextStyle(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Total : ${item.item.total}',
                style: TextStyle(
                    color: AppColors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future getTxnToken() async
  {
    // return txnToken
  }
}
