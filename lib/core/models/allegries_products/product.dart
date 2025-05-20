class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  int? categoryId;
  String? productImg;
  String? schoolTenantId;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.productImg,
    this.schoolTenantId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: json['price'] as double?,
        categoryId: json['categoryId'] as int?,
        productImg: json['productImg'] as String?,
        schoolTenantId: json['schoolTenantId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'productImg': productImg,
        'schoolTenantId': schoolTenantId,
      };
}
