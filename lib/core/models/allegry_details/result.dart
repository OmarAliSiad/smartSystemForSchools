import 'category.dart';

class Result {
  String? id;
  Category? category;

  Result({this.id, this.category});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category?.toJson(),
      };
}
