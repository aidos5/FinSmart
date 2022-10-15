import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  String name;
  int quantity;
  int minimumQuantity;
  String unit;
  int sellingPrice;
  int taxes;
  DateTime expDate;
  int itemPrice;

  ModelItem({
    required this.name,
    required this.quantity,
    required this.minimumQuantity,
    this.unit = '',
    required this.sellingPrice,
    this.taxes = 0,
    required this.expDate,
    required this.itemPrice,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'minimumQuantity': minimumQuantity,
        'unit': unit,
        'sellingPrice': sellingPrice,
        'taxes': taxes,
        'expDate': expDate,
        'itemPrice': (sellingPrice - taxes),
      };

  static ModelItem fromJson(Map<String, dynamic> json) => ModelItem(
        name: json['name'],
        quantity: json['quantity'],
        minimumQuantity: json['minimumQuantity'],
        unit: json['unit'],
        sellingPrice: json['sellingPrice'],
        taxes: json['taxes'],
        expDate: (json['expDate'] as Timestamp).toDate(),
        itemPrice: json['itemPrice'],
      );
}
