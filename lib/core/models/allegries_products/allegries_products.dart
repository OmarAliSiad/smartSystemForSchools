import 'result.dart';

class AllegriesProducts {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<Result>? result;

  AllegriesProducts({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory AllegriesProducts.fromJson(Map<String, dynamic> json) {
    return AllegriesProducts(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
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
