import 'result.dart';

class CatgoryDetails {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<CatogryResult>? result;

  CatgoryDetails({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory CatgoryDetails.fromJson(Map<String, dynamic> json) {
    return CatgoryDetails(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => CatogryResult.fromJson(e as Map<String, dynamic>))
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
