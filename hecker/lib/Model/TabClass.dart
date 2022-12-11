import 'package:flutter/material.dart';
import 'ModelItem.dart';
import 'Bill.dart';

class TabClass {
  List<int>? count = [];
  Tab? billtabs;
  List<TextEditingController>? quantityEditor = [];
  List<ModelItem>? allItems;
  List<ModelItem>? foundItems;
  Bill? bill;

  bool? showPaymentView = false;

  TabClass(
      {this.foundItems,
      this.billtabs,
      this.count,
      this.quantityEditor,
      this.showPaymentView,
      this.bill});
}
