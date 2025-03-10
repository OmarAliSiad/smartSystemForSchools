import 'result.dart';

class AttendanceModel {
  int? statusCode;
  bool? isSuccess;
  String? message;
  List<Result>? result;
  String? resultForVaction;

  AttendanceModel({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
    this.resultForVaction,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: json['result'] != null
          ? List<Result>.from(json['result'].map((x) => Result.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
