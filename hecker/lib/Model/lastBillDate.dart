// import 'package:json_serializable/json_serializable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:json_serializable/builder.dart';

part 'lastBillDate.g.dart';

//@JsonSerializable()
class lastBillDate {
  String? lastBill;
  String? iterator;

  lastBillDate();

  factory lastBillDate.fromJson(Map<String, dynamic> data) =>
      _$lastBillDateFromJson(data);

  Map<String, dynamic> toJson() => _$lastBillDateToJson(this);
}
