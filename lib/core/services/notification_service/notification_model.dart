class NotificationProductModel {
  final String route;
  final String studentId;
  final String amountOfMoney;
  String? id;
  String? name;
  dynamic description;
  String? price;
  String? categoryId;
  String? message;
  dynamic productImg;
  String? quantity; // Added quantity property
  String? reason;
  NotificationProductModel({
    required this.route,
    required this.studentId,
    required this.amountOfMoney,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.productImg,
    required this.message,
    required this.quantity,
    required this.reason,
  });

  factory NotificationProductModel.fromJson(Map<String, dynamic> json) {
    return NotificationProductModel(
      route: json['route'] as String,
      studentId: json['studentId'] as String,
      amountOfMoney: json['amountOfMoney'].toString(),
      id: json['id'] as String?,
      name: json['name'] as String?,
      reason: json['reason'] as String?,
      description: json['description'] as dynamic,
      price: json['price'] as String?,
      message: json['message'] as String?,
      categoryId: json['categoryId'] as String?,
      productImg: json['productImg'] as dynamic,
      quantity: json['quantity'] as String?, //
    );
  }

  Map<String, dynamic> toJson() => {
        'route': route,
        'studentId': studentId,
        'amountOfMoney': amountOfMoney,
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'productImg': productImg,
        'quantity': quantity,
      };
}
