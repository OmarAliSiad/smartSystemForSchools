import 'result.dart';

class GetNotificatoinDetails {
  int? statusCode;
  bool? isSuccess;
  String? message;
  ResultForNotificationDetails? result;

  GetNotificatoinDetails({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory GetNotificatoinDetails.fromJson(Map<String, dynamic> json) {
    return GetNotificatoinDetails(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ResultForNotificationDetails.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.toJson(),
      };
}
