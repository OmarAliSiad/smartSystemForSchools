class ChildAttendceModel {
  int? statusCode;
  bool? isSuccess;
  String? message;
  String? result;

  ChildAttendceModel({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.result,
  });

  factory ChildAttendceModel.fromJson(Map<String, dynamic> json) {
    return ChildAttendceModel(
      statusCode: json['statusCode'] as int?,
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      result: json['result'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isSuccess': isSuccess,
        'message': message,
        'result': result,
      };
}
