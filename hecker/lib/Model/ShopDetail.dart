import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'ShopDetail.g.dart';

@JsonSerializable()
class ShopDetail {
  String? id;

  String? name;
  String? address;
  String? pincode;

  String? contactNumber;
  String? contactMail;

  String? categoryCode;
  String? gstn;

  String? upiVPA;

  ShopDetail();

  /// factory.
  factory ShopDetail.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ShopDetailToJson(this);
}

class ShopID {
  String? id;

  ShopID({this.id});

  factory ShopID.fromJson(Map<String, dynamic> json) => ShopID(id: json['id']);
}
