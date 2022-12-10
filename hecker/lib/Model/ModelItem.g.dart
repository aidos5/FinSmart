// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelItem _$ModelItemFromJson(Map<String, dynamic> json) => ModelItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String? ?? '',
      rate: (json['rate'] as num).toDouble(),
      taxes: json['taxes'] as int? ?? 0,
      expDate: json['expDate'] as String,
      total: json['total'] as int,
    );

Map<String, dynamic> _$ModelItemToJson(ModelItem instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'quantity': instance.quantity,
      'id': instance.id,
      'unit': instance.unit,
      'rate': instance.rate,
      'taxes': instance.taxes,
      'expDate': instance.expDate,
      'total': instance.total,
    };
