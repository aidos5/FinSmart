// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      billID: json['billID'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => BillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMode: json['paymentMode'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      customerName: json['customerName'] as String,
      customerNumber: json['customerNumber'] as String,
      customerAddress: json['customerAddress'] as String,
      customerGSTN: json['customerGSTN'] as String,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'billID': instance.billID,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'paymentMode': instance.paymentMode,
      'dateTime': instance.dateTime.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'customerName': instance.customerName,
      'customerNumber': instance.customerNumber,
      'customerAddress': instance.customerAddress,
      'customerGSTN': instance.customerGSTN,
    };
