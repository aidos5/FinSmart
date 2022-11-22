// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShopDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopDetail _$ShopDetailFromJson(Map<String, dynamic> json) => ShopDetail()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..address = json['address'] as String?
  ..pincode = json['pincode'] as String?
  ..contactNumber = json['contactNumber'] as String?
  ..contactMail = json['contactMail'] as String?
  ..categoryCode = json['categoryCode'] as String?
  ..gstn = json['gstn'] as String?
  ..upiVPA = json['upiVPA'] as String?;

Map<String, dynamic> _$ShopDetailToJson(ShopDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'pincode': instance.pincode,
      'contactNumber': instance.contactNumber,
      'contactMail': instance.contactMail,
      'categoryCode': instance.categoryCode,
      'gstn': instance.gstn,
      'upiVPA': instance.upiVPA,
    };
