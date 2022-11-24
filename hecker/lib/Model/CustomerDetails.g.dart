// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerDetails _$CustomerDetailsFromJson(Map<String, dynamic> json) =>
    CustomerDetails(
      name: json['name'] as String?,
      contactNumber: json['contactNumber'] as String?,
      contactMail: json['contactMail'] as String?,
      gstn: json['gstn'] as String?,
    );

Map<String, dynamic> _$CustomerDetailsToJson(CustomerDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contactNumber': instance.contactNumber,
      'contactMail': instance.contactMail,
      'gstn': instance.gstn,
    };
