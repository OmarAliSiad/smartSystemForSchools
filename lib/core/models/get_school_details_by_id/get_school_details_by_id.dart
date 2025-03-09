import 'result.dart';

class SchoolDetails {
  int? statusCode;
  bool? isSuccess;
  String? message;
  ResultForSpecificSchool? result;

  SchoolDetails({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory SchoolDetails.fromJson(Map<String, dynamic> json) {
    return SchoolDetails(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ResultForSpecificSchool.fromJson(
              json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.toJson(),
      };
}
