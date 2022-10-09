import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/Model/ModelItem.dart';
import 'package:hecker/Navigation.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        print('Back button pressed');
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AddItems()),
                  (route) => false);
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            centerTitle: true,
            
            title: Text(
              'FinSmart',
              style: TextStyle(fontSize: 37),
              
            ),
          ),
          body: StreamBuilder<List<ModelItem>>(
            stream: readItem(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('There is an error ${snapshot.error}');
              } else if (snapshot.hasData) {
                final items = snapshot.data!;

                return ListView.builder(
                  // itemBuilder: (context, index) {
                  //   items.map(buildItem).toList();
                  //   throw '';
                  // },

                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final sortedItems = items.reversed;
                    return Card(
                      child: Column(
                        children: [
                          // ignore: unnecessary_string_interpolations
                          Row(
                            children: [
                              Text(
                                'Name : ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${items[index].name}',
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
                                '${items[index].quantity} ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text('${items[index].unit}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Selling Price : ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text('${items[index].price}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          MaterialButton(
                            onPressed: (() {}),
                            child: Text('Update'),
                            color: Colors.green,
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }

  Stream<List<ModelItem>> readItem() => FirebaseFirestore.instance
      .collection('transactions')
      .doc('category')
      .collection('pincode')
      .doc('shopid')
      .collection('items')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ModelItem.fromJson(doc.data())).toList());
}
