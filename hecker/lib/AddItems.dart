import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/ModelItem.dart';

class AddItems extends StatefulWidget {
  AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final itemName = TextEditingController();
  final quantity = TextEditingController();
  final minimumQuantity = TextEditingController();
  final unit = TextEditingController();
  final sellingPrice = TextEditingController();
  final taxes = TextEditingController();
  final expDate = TextEditingController();

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
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: screenwidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Item Name', border: OutlineInputBorder()),
                  controller: itemName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                  controller: quantity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Minimum Quantity',
                      border: OutlineInputBorder()),
                  controller: minimumQuantity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Enter unit', border: OutlineInputBorder()),
                  controller: unit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Selling Pricet',
                      border: OutlineInputBorder()),
                  controller: sellingPrice,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Taxes', border: OutlineInputBorder()),
                  controller: taxes,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Expiry Date', border: OutlineInputBorder()),
                  controller: expDate,
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

  Future SaveAll() async {
    final item = ModelItem(
      name: itemName.text,
      quantity: int.parse(quantity.text),
      minimumQuantity: int.parse(minimumQuantity.text),
      unit: unit.text,
      sellingPrice: int.parse(sellingPrice.text),
      taxes: int.parse(taxes.text),
      expDate: DateTime.now(),
      price: int.parse(quantity.text) *
          (int.parse(sellingPrice.text) - int.parse(taxes.text)),
    );

    final doc = item.toJson();
    final docuser = FirebaseFirestore.instance
        .collection('finsmart_transactions')
        .doc('finsmart_transactions_pincode')
        .collection('finsmart_transactions_shopid')
        .doc('generalDetails')
        .collection('items')
        .doc('${itemName.text + '_' + unit.text}');

    await docuser.set(doc);
  }
}
