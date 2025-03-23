class Result {
  String? studentId;
  double? amountOfMoney;
  double? dailySpendingLimit;
  dynamic weeklySpendingLimit;
  dynamic monthlySpendingLimit;

  Result({
    this.studentId,
    this.amountOfMoney,
    this.dailySpendingLimit,
    this.weeklySpendingLimit,
    this.monthlySpendingLimit,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        studentId: json['studentId'] as String?,
        amountOfMoney: json['amountOfMoney'] as double?,
        dailySpendingLimit: json['dailySpendingLimit'] as double?,
        weeklySpendingLimit: json['weeklySpendingLimit'] as dynamic,
        monthlySpendingLimit: json['monthlySpendingLimit'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'amountOfMoney': amountOfMoney,
        'dailySpendingLimit': dailySpendingLimit,
        'weeklySpendingLimit': weeklySpendingLimit,
        'monthlySpendingLimit': monthlySpendingLimit,
      };
}
