import 'result.dart';

class MoneyRechargeModel {
  int? statusCode;
  bool? isSuccess;
  String? message;
  Result? result;

  MoneyRechargeModel({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory MoneyRechargeModel.fromJson(Map<String, dynamic> json) {
    return MoneyRechargeModel(
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
