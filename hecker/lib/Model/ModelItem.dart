class ModelItem {
  String name;
  int quantity;
  int minimumQuantity;
  String unit;
  int sellingPrice;
  int taxes;
  DateTime expDate;
  int price;

  ModelItem({
    required this.name,
    required this.quantity,
    required this.minimumQuantity,
    this.unit = '',
    required this.sellingPrice,
    this.taxes = 0,
    required this.expDate,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'minimumQuantity': minimumQuantity,
        'unit': unit,
        'sellingPrice': sellingPrice,
        'taxes': taxes,
        'expDate': expDate,
        'price': price
      };
}
