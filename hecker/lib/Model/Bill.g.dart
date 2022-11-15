// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      billID: json['billID'] as String,
      customerDetails: json['customerDetails'] as String,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'items': instance.items,
      'billID': instance.billID,
      'customerDetails': instance.customerDetails,
    };
