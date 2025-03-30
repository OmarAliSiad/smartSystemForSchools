class StudentTransactionItem {
  String? productId;
  String? productName;
  double? price;
  int? quantity;

  StudentTransactionItem({
    this.productId,
    this.productName,
    this.price,
    this.quantity,
  });

  factory StudentTransactionItem.fromJson(Map<String, dynamic> json) {
    return StudentTransactionItem(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      price: json['price'] as double?,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
      };
}
