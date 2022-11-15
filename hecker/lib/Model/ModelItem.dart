import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ModelItem.g.dart';

@JsonSerializable()
class ModelItem {
  String name;
  String description;
  int quantity;
  String id;

  String unit;
  int rate;
  int taxes;
  String expDate;
  int itemPrice;
  int total;

  ModelItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.unit = '',
    required this.rate,
    this.taxes = 0,
    required this.expDate,
    required this.itemPrice,
    required this.total,
  });

  /// factory.
  factory ModelItem.fromJson(Map<String, dynamic> json) =>
      _$ModelItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ModelItemToJson(this);
}

class SerialNumber {
  String? id;

  SerialNumber({this.id});

  factory SerialNumber.fromJson(Map<String, dynamic> json) =>
      SerialNumber(id: json['id']);
}
