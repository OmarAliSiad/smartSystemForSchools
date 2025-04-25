class Result {
  String? parentId;
  double? amountOfMoney;

  Result({this.parentId, this.amountOfMoney});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        parentId: json['parentId'] as String?,
        amountOfMoney: json['amountOfMoney'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'parentId': parentId,
        'amountOfMoney': amountOfMoney,
      };
}
