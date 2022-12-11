import 'package:flutter/material.dart';
import 'package:hecker/Model/Bill.dart';
import 'package:hecker/Model/ModelItem.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:intl/intl.dart';

class BuyStuffPayments extends StatefulWidget {
  BuyStuffPayments({this.bill, this.shopDetail, Key? key}) : super(key: key);

  Bill? bill;
  ShopDetail? shopDetail;

  @override
  State<BuyStuffPayments> createState() =>
      _BuyStuffPaymentsState(bill: bill, shopDetail: shopDetail);
}

class _BuyStuffPaymentsState extends State<BuyStuffPayments> {
  Bill? bill;
  ShopDetail? shopDetail;
  _BuyStuffPaymentsState({this.bill, this.shopDetail});

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

  void processPayment(Bill bill, String method) {
  }

  // Future generateBill() async {
  //   // var formatter = new DateFormat('ddMMyyyy');
  //   // String date = formatter.format(DateTime.now());

  //   // String? lastBillDate = await localStoragebillDate.getItem('lastBilldate');
  //   // if (lastBillDate == null) {
  //   //   await localStoragebillDate.setItem('lastBillDate', date);
  //   //   lastBillDate = date;
  //   // }

  //   // var billC = await localStoragebillDate.getItem('billCount');
  //   // if (billC == null || lastBillDate != date) {
  //   //   await localStoragebillDate.setItem('billCount', '0');
  //   //   billC = '0';
  //   // }
  //   // int billCount = int.parse(billC.toString());
  //   // billCount++;
  //   // await localStoragebillDate.setItem('billCount', billCount.toString());

  //   // //{payment mode}{shop id}{date}{bill count of that day}
  //   // String billNumber = "11${shopDetail!.id}${date}${billCount}";
  //   // String billID = GetBillID(BigInt.parse(billNumber));

  //   // List<BillItem> items = [];
  //   // TabClass curTab = tC[currentTabIndex];

  //   List<ModelItem> items = [];

  //   for (int i = 0; i < displayItems.count!.length; i++) {
  //     if (curTab.count![i] != 0) {
  //       items.add(new BillItem(
  //           item: curTab.allItems![i],
  //           quantity: curTab.count![i].toDouble(),
  //           totalAmount:
  //               curTab.allItems![i].rate * curTab.count![i].toDouble()));
  //     }
  //   }

  //   double totalCost = 0;
  //   for (var i in items) {
  //     totalCost += i.totalAmount;
  //   }

  //   Bill bill = Bill(
  //       billID: billID,
  //       items: items,
  //       paymentMode: "UPI",
  //       dateTime: DateTime.now(),
  //       totalAmount: totalCost,
  //       customerName: "customerName",
  //       customerNumber: "customerNumber",
  //       customerAddress: "customerAddress",
  //       customerGSTN: "customerGSTN");

  //   //print(bill.totalCost);

  //   var billJSON = bill.toJson(); //bill.toJson().toString();
  //   print("Bill : " + billJSON.toString());
  //   final docuser = FirebaseFirestore.instance
  //       .collection('transactions')
  //       .doc('category')
  //       .collection('pincode')
  //       .doc('shopid')
  //       .collection('bills')
  //       .doc('offlineBills')
  //       .collection("day2")
  //       .doc("part1");

  //   List<dynamic> billArr = [];
  //   billArr.add(billJSON);

  //   // Store it in local storage
  //   await docuser.set(
  //       {'bills': FieldValue.arrayUnion(billArr)}, SetOptions(merge: true));

  //   setState(() {
  //     tC[currentTabIndex].bill = bill;
  //     tC[currentTabIndex].showPaymentView = true;
  //   });

  //   // GetPaymentLink(bill);
  // }
}
