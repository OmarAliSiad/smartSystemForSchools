import 'result.dart';

class AllegryCatogryDetails {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<Result>? result;

  AllegryCatogryDetails({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory AllegryCatogryDetails.fromJson(Map<String, dynamic> json) {
    return AllegryCatogryDetails(
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
