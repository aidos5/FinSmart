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
  ..shopType = json['shopType'] as String?
  ..gstn = json['gstn'] as String?
  ..upiVPA = json['upiVPA'] as String?
  ..proximityHashes = (json['proximityHashes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..geoHash = json['geoHash'] as String?
  ..owner = json['owner'] == null
      ? null
      : UserCredential.fromJson(json['owner'] as Map<String, dynamic>)
  ..workers = (json['workers'] as List<dynamic>?)
      ?.map((e) => UserCredential.fromJson(e as Map<String, dynamic>))
      .toList()
  ..allItems = (json['allItems'] as List<dynamic>?)
      ?.map((e) => ModelItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ShopDetailToJson(ShopDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'pincode': instance.pincode,
      'contactNumber': instance.contactNumber,
      'contactMail': instance.contactMail,
      'shopType': instance.shopType,
      'gstn': instance.gstn,
      'upiVPA': instance.upiVPA,
      'proximityHashes': instance.proximityHashes,
      'geoHash': instance.geoHash,
      'owner': instance.owner?.toJson(),
      'workers': instance.workers?.map((e) => e.toJson()).toList(),
      'allItems': instance.allItems?.map((e) => e.toJson()).toList(),
    };
