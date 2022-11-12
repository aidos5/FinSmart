// import 'package:json_serializable/json_serializable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:json_serializable/builder.dart';

part 'storeItems.g.dart';

//@JsonSerializable()
class storeItems {
  List<Map<String, dynamic>>? allItem;

  storeItems();

  factory storeItems.fromJson(Map<String, dynamic> data) =>
      (_$storeItemsFromJson(data));

  Map<String, dynamic> toJson() => (_$storeItemsToJson(this));
}
