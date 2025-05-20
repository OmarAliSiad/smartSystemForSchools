class Result {
  String? studentName;
  double? amountOfMoney;
  DateTime? createdAt;

  Result({this.studentName, this.amountOfMoney, this.createdAt});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        studentName: json['studentName'] as String?,
        amountOfMoney: json['amountOfMoney'] as double?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'amountOfMoney': amountOfMoney,
        'createdAt': createdAt?.toIso8601String(),
      };
}
