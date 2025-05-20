import 'result.dart';

class GetAllProducts {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<ResultForProducts>? result;

  GetAllProducts({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory GetAllProducts.fromJson(Map<String, dynamic> json) {
    return GetAllProducts(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => ResultForProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
