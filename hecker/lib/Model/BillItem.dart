import 'ModelItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BillItem.g.dart';

@JsonSerializable(explicitToJson: true)
class BillItem {
  ModelItem item;
  double quantity;
  double totalAmount;

  BillItem({
    required this.item,
    required this.quantity,
    required this.totalAmount,
  });

  /// factory.
  factory BillItem.fromJson(Map<String, dynamic> json) =>
      _$BillItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BillItemToJson(this);
}
