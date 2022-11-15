import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'ModelItem.dart';

part 'Bill.g.dart';

@JsonSerializable(explicitToJson: true)
class Bill {
  List<String> items = [];
  String billID;
  String customerDetails;

  Bill({
    required this.items,
    required this.billID,
    required this.customerDetails,
  });

  /// factory.
  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BillToJson(this);
}
