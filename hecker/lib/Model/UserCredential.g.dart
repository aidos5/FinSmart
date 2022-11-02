// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserCredential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCredential _$UserCredentialFromJson(Map<String, dynamic> json) =>
    UserCredential()
      ..shopID = json['shopID'] as String
      ..phoneNo = json['phoneNo'] as String
      ..name = json['name'] as String
      ..address = json['address'] as String
      ..gender = json['gender'] as String
      ..dob = json['dob'] as String
      ..regDate = json['regDate'] as String
      ..isOwner = json['isOwner'] as bool
      ..passHash = json['passHash'] as String;

Map<String, dynamic> _$UserCredentialToJson(UserCredential instance) =>
    <String, dynamic>{
      'shopID': instance.shopID,
      'phoneNo': instance.phoneNo,
      'name': instance.name,
      'address': instance.address,
      'gender': instance.gender,
      'dob': instance.dob,
      'regDate': instance.regDate,
      'isOwner': instance.isOwner,
      'passHash': instance.passHash,
    };
