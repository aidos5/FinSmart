import 'dart:convert';

import 'package:hecker/Model/ModelItem.dart';
import 'package:hecker/Model/UserCredential.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ShopDetail.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopDetail {
  String? id;

  String? name;
  String? address;
  String? pincode;

  String? contactNumber;
  String? contactMail;

  String? shopType;
  String? gstn;

  String? upiVPA;

  List<String>? proximityHashes;
  String? geoHash;

  UserCredential? owner;
  List<UserCredential>? workers;

  List<ModelItem>? allItems;

  @JsonKey(ignore: true)
  String? paytmMID;
  @JsonKey(ignore: true)
  String? paytmKey;

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
