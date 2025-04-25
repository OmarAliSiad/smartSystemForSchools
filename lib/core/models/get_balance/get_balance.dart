import 'result.dart';

class GetBalance {
  int? statusCode;
  bool? isSuccess;
  String? message;
  Result? result;

  GetBalance({this.statusCode, this.isSuccess, this.message, this.result});

  factory GetBalance.fromJson(Map<String, dynamic> json) => GetBalance(
        statusCode: json['statusCode'] as int?,
        isSuccess: json['isSuccess'] as bool?,
        message: json['message'] as String?,
        result: json['result'] == null
            ? null
            : Result.fromJson(json['result'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.toJson(),
      };
}
