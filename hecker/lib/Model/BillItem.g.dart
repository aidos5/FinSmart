// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillItem _$BillItemFromJson(Map<String, dynamic> json) => BillItem(
      item: ModelItem.fromJson(json['item'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$BillItemToJson(BillItem instance) => <String, dynamic>{
      'item': instance.item.toJson(),
      'quantity': instance.quantity,
      'totalAmount': instance.totalAmount,
    };
