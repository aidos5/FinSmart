import 'package:json_annotation/json_annotation.dart';

part 'UserCredential.g.dart';

@JsonSerializable()
class UserCredential {
  // Shop ID associated with
  String shopID = "";

  // Personal Details
  String phoneNo = "";
  String name = "";
  String address = "";
  String gender = "";
  String dob = "";
  String regDate = "";

  // User level
  bool? isOwner = false;

  // Password Hash
  String passHash = "";

  UserCredential();

  //JSON Stuff
  /// factory.
  factory UserCredential.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserCredentialToJson(this);
}
