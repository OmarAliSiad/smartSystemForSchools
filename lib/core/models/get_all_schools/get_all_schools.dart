import 'result.dart';

class GetAllSchools {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<ResultForAllSchools>? result;

  GetAllSchools({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory GetAllSchools.fromJson(Map<String, dynamic> json) => GetAllSchools(
        statusCode: json['statusCode'] as int?,
        isSuccess: json['isSuccess'] as bool?,
        message: json['message'] as String?,
        result: (json['result'] as List<dynamic>?)
            ?.map(
                (e) => ResultForAllSchools.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
