// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeItems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

storeItems _$storeItemsFromJson(Map<String, dynamic> json) => storeItems()
  ..allItem = (json['allItem'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList();

Map<String, dynamic> _$storeItemsToJson(storeItems instance) =>
    <String, dynamic>{
      'allItem': instance.allItem,
    };
