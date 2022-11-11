import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/Items.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';
import 'Model/ModelItem.dart';

import 'package:http/http.dart' as http;

class AddItems extends StatefulWidget {
  AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final itemName = TextEditingController();
  final itemDescription = TextEditingController();
  final quantity = TextEditingController();
  final unit = TextEditingController();
  final rate = TextEditingController();
  final taxes = TextEditingController();
  final expDate = TextEditingController();

  String? scanResult;

  var localStorageItems = new LocalStorage('items.json');

  Future<String?> GetSerialNumber() async {
    var response =
        await http.get(Uri.parse("https://productid.finsmart.workers.dev"));

    SerialNumber id = SerialNumber.fromJson(jsonDecode(response.body));

    return id.id ?? null;
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
            onPressed: scanBarcode,
          )
        ],
        leading: MaterialButton(
          onPressed: (() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Items()),
                (route) => false);
          }),
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        title: Text(
          'FinSmart',
          style: TextStyle(fontSize: 37),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: screenwidth,
          child: Column(
            children: [
              Text(
                scanResult == null
                    ? 'No Serial Number'
                    : 'Serial Number : $scanResult',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: itemName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Item Description',
                      border: OutlineInputBorder()),
                  controller: itemDescription,
                ),
              ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: const InputDecoration(
// <<<<<<< HEAD
//                       labelText: 'Minimum Quantity',
//                       border: OutlineInputBorder()),
//                   controller: minimumQuantity,
//                   keyboardType: TextInputType.number,
// =======
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                       labelText: 'Enter unit', border: OutlineInputBorder()),
//                   controller: unit,
//                 ),
//               ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Selling Price', border: OutlineInputBorder()),
                  controller: rate,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Taxes', border: OutlineInputBorder()),
                  controller: taxes,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Expiry Date', border: OutlineInputBorder()),
                  controller: expDate,
                  keyboardType: TextInputType.datetime,
                ),
              ),
              MaterialButton(
                onPressed: (() {
                  SaveAll();
                }),
                child: Text('Save'),
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future scanBarcode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#FF0000", "close", true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = "Failed to get platfor exception";
    }

    if (!mounted) return;
    setState(() {
      this.scanResult = scanResult;
    });
  }

  Future SaveAll() async {
<<<<<<< Updated upstream
    final docuser;
    String? id = scanResult;

    String? serialNumber = "";
    while (serialNumber!.isEmpty) {
      serialNumber = await GetSerialNumber();
    }

    if(id == null)
    {
      id = serialNumber;
    }
    
=======
    final item = ModelItem(
      name: itemName.text,
      description: itemDescription.text,
      quantity: int.parse(quantity.text),
      unit: unit.text,
      rate: int.parse(rate.text),
      taxes: int.parse(taxes.text),
      expDate: DateTime.now(),
      itemPrice: (int.parse(rate.text) - int.parse(taxes.text)),
      total: int.parse(rate.text) * int.parse(quantity.text),
    );

    final doc = item.toJson();
    final DocumentReference<Map<String, dynamic>> docuser;
>>>>>>> Stashed changes
    if (scanResult != null) {
      docuser = FirebaseFirestore.instance
          .collection('transactions')
          .doc('category')
          .collection('pincode')
          .doc('shopid')
          .collection('items')
          .doc('$scanResult');

          await localStorageItems.setItem('$scanResult', List<ModelItem>);
    } else {
      docuser = FirebaseFirestore.instance
          .collection('transactions')
          .doc('category')
          .collection('pincode')
          .doc('shopid')
          .collection('items')
          .doc(serialNumber);
          await localStorageItems.setItem(serialNumber, List<ModelItem>);
    }
<<<<<<< Updated upstream

    final item = ModelItem(
      id: id,
      name: itemName.text,
      description: itemDescription.text,
      quantity: int.parse(quantity.text),
      unit: unit.text,
      rate: int.parse(rate.text),
      taxes: int.parse(taxes.text),
      expDate: DateTime.now(),
      itemPrice: (int.parse(rate.text) - int.parse(taxes.text)),
      total: int.parse(rate.text) * int.parse(quantity.text),
    );

    final doc = item.toJson();

=======
    
>>>>>>> Stashed changes
    await docuser.set(doc);
  }
}
