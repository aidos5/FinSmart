import 'package:cloud_firestore/cloud_firestore.dart';
import 'ModelItem.dart';

class Bill {
  String shopName;
  String shopAddress;
  String GSTNumber;
  List<Map<String, dynamic>> billJson = [];
  int totalCost;
  String billNumber;
  String paymentMode;
  String customerName;
  String customerNumber;

  Bill({
    required this.shopName,
    required this.shopAddress,
    required this.GSTNumber,
    required this.billJson,
    required this.totalCost,
    required this.billNumber,
    required this.paymentMode,
    required this.customerName,
    required this.customerNumber,
  });

  Map<String, dynamic> toJson() => {
        'shopName': shopName,
        'shopAddress': shopAddress,
        'GSTNumber': GSTNumber,
        'billJson': billJson,
        'totalCost': totalCost,
        'billNumber': billNumber,
        'paymentMode': paymentMode,
        'customerName': customerName,
        'customerNumber': customerNumber,
      };

  static Bill fromJson(Map<String, dynamic> json) => Bill(
        shopName: json['shopName'],
        shopAddress: json['shopAddress'],
        GSTNumber: json['GSTNumber'],
        billJson: json['billJson'],
        totalCost: json['totalCost'],
        billNumber: json['billNumber'],
        paymentMode: json['paymentMode'],
        customerName: json['customerName'],
        customerNumber: json['customerNumber'],
      );
}
