import 'product.dart';

class Result {
  String? id;
  Product? product;

  Result({this.id, this.product});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'] as String?,
        product: json['product'] == null
            ? null
            : Product.fromJson(json['product'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product?.toJson(),
      };
}
