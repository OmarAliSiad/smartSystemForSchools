import 'result.dart';

class GetChildDetails {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<ResultForChildDetails>? result;

  GetChildDetails({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory GetChildDetails.fromJson(Map<String, dynamic> json) {
    return GetChildDetails(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map(
              (e) => ResultForChildDetails.fromJson(e as Map<String, dynamic>))
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
