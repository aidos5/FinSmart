import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  String name;
  int quantity;
  int minimumQuantity;
  String unit;
  int rate;
  int taxes;
  DateTime expDate;
  int itemPrice;
  int total;

  ModelItem({
    required this.name,
    required this.quantity,
    required this.minimumQuantity,
    this.unit = '',
    required this.rate,
    this.taxes = 0,
    required this.expDate,
    required this.itemPrice,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'minimumQuantity': minimumQuantity,
        'unit': unit,
        'rate': rate,
        'taxes': taxes,
        'expDate': expDate,
        'itemPrice': (rate - taxes),
        'total': quantity*rate
      };

  static ModelItem fromJson(Map<String, dynamic> json) => ModelItem(
        name: json['name'],
        quantity: json['quantity'],
        minimumQuantity: json['minimumQuantity'],
        unit: json['unit'],
        rate: json['rate'],
        taxes: json['taxes'],
        expDate: (json['expDate'] as Timestamp).toDate(),
        itemPrice: json['itemPrice'],
        total: json['total'],
      );
}
