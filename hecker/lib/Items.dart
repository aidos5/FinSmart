import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/Model/ModelItem.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Stream<List<ModelItem>> dataItems = readItem();

  List<ModelItem> allItems = [];
  List<ModelItem> foundItems = [];

  @override
  void initState() {
    // TODO: implement initState
    dataItems.listen((listofitems) {
      for (ModelItem i in listofitems) {
        allItems.add(i);
      }
    });

    foundItems = List.from(allItems);
    super.initState();
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FinSmart',
          style: TextStyle(fontSize: 37),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
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
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      onChanged: searchItems,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: foundItems.length,
                      itemBuilder: (context, index) {
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
                                  Text('${foundItems[index].unit}',
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Selling Price : ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text('${foundItems[index].price}',
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
                    ),
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
      ),
    );
  }

  void searchItems(String query) {
    List<ModelItem> results = [];
    if (query.isEmpty) {
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
