import 'result.dart';

class ChildTransactionsModel {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<Result>? result;

  ChildTransactionsModel(
      {this.statusCode, this.isSuccess, this.message, this.result});

  factory ChildTransactionsModel.fromJson(Map<String, dynamic> json) =>
      ChildTransactionsModel(
        statusCode: json['statusCode'] as int?,
        isSuccess: json['isSuccess'] as bool?,
        message: json['message'] as String?,
        result: (json['result'] as List<dynamic>?)
            ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
