import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/AddItems.dart';
import 'package:hecker/MainPage.dart';
import 'package:hecker/Model/ModelItem.dart';
import 'package:hecker/UI/Colors.dart';
import 'package:localstorage/localstorage.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var localStorageItems = LocalStorage('items.json');

  List<ModelItem> allItems = [];
  List<ModelItem> foundItems = [];

  bool firstopen = true;
  bool isInit = false;

  @override
  void initState() {
    // TODO: implement initState
    LoadItems();
  }

  Future LoadItems() async {
    var temp = await (localStorageItems.getItem('items'));
    if (temp != null) {
      List allItemString = (jsonDecode(temp) as List<dynamic>);

      for (dynamic s in allItemString) {
        allItems.add(ModelItem.fromJson(jsonDecode(s)));
      }
    }

    foundItems = List.from(allItems);
    setState(() {
      isInit = true;
    });
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final screenwidth = MediaQuery.of(context).size.width;
    return !isInit
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Finsmart",
                style: TextStyle(fontSize: 37),
              ),
              leading: MaterialButton(
                onPressed: (() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false);
                }),
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: AppColors.black,
                ),
              ),
            ),
            body: Center(
              child: Text("Loading..."),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'FinSmart',
                style: TextStyle(fontSize: 37),
              ),
              leading: MaterialButton(
                onPressed: (() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false);
                }),
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: AppColors.black,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddItems()),
                    (route) => false);
              },
              child: Icon(Icons.add),
            ),
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Expanded(
                child: Column(
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
                      itemCount: firstopen == true
                          ? allItems.length
                          : foundItems.length,
                      itemBuilder: (context, index) {
                        final screenwidth = MediaQuery.of(context).size.width;
                        List<Color> cardColor = [
                          AppColors.blueCard,
                          AppColors.pinkCard,
                          AppColors.orangeCard
                        ];
                        return firstopen == false
                            ? Card(
                                color: cardColor[index],
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Name : ${foundItems[index].name}',
                                              style: TextStyle(
                                                  color: AppColors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenwidth / 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Quantity left: ${foundItems[index].quantity} ${foundItems[index].unit}',
                                              style: TextStyle(
                                                  color: AppColors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Selling Price : ${foundItems[index].rate}',
                                              style: TextStyle(
                                                  color: AppColors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      onPressed: (() {}),
                                      child: Text('Update'),
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              )
                            : Card(
                                color: cardColor[index],
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Name : ${allItems[index].name}',
                                            style: TextStyle(
                                                color: AppColors.black
                                                    .withOpacity(0.8),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: screenwidth / 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Quantity left: ${allItems[index].quantity} ${allItems[index].unit}',
                                              style: TextStyle(
                                                  color: AppColors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Selling Price : ${allItems[index].rate}',
                                            style: TextStyle(
                                                color: AppColors.black
                                                    .withOpacity(0.8),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
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
      firstopen = false;
      foundItems = List.from(results);
    });
  }
}
