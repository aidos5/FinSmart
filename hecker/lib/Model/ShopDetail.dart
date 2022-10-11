import 'package:json_annotation/json_annotation.dart';

part 'ShopDetail.g.dart';

@JsonSerializable()
class ShopDetail {
  String? name;
  String? address;
  String? pincode;

  String? contactNumber;
  String? contactMail;

  String? categoryCode;
  String? gstn;

  ShopDetail();

  /// factory.
  factory ShopDetail.fromJson(Map<String, dynamic> json) => _$ShopDetailFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ShopDetailToJson(this);
}
