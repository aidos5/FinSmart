import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hecker/Model/BillItem.dart';
import 'package:json_annotation/json_annotation.dart';
import 'ModelItem.dart';

part 'Bill.g.dart';

@JsonSerializable(explicitToJson: true)
class Bill {
  String billID;

  List<BillItem> items = [];

  String paymentMode;
  DateTime dateTime;
  
  double totalAmount;

  String customerName;
  String customerNumber;
  String customerAddress;
  String customerGSTN;

  Bill({
    required this.billID,
    required this.items,
    required this.paymentMode,
    required this.dateTime,
    required this.totalAmount,
    required this.customerName,
    required this.customerNumber,
    required this.customerAddress,
    required this.customerGSTN,
  });

  /// factory.
  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BillToJson(this);
}
