import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'CustomerDetails.g.dart';

@JsonSerializable()
class CustomerDetails {
  String? name;
  String? contactNumber;
  String? contactMail;
  String? address;
  String? gstn;

  CustomerDetails(
      {required this.name,
      required this.contactNumber,
      this.contactMail,
      this.address,
      this.gstn});

  /// factory.
  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      _$CustomerDetailsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CustomerDetailsToJson(this);
}
