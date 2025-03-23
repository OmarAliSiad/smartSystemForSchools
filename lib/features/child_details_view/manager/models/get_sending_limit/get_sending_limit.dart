import 'result.dart';

class GetSendingLimit {
  int? statusCode;
  bool? isSuccess;
  String? message;
  Result? result;

  GetSendingLimit({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory GetSendingLimit.fromJson(Map<String, dynamic> json) {
    return GetSendingLimit(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.toJson(),
      };
}
