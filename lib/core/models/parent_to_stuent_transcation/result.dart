class Result {
  String? parentToStudentTransactionId;

  Result({this.parentToStudentTransactionId});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        parentToStudentTransactionId:
            json['parentToStudentTransactionId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'parentToStudentTransactionId': parentToStudentTransactionId,
      };
}
