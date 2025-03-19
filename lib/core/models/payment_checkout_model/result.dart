class Result {
  String? sessionId;
  String? pubKey;

  Result({this.sessionId, this.pubKey});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        sessionId: json['sessionId'] as String?,
        pubKey: json['pubKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'pubKey': pubKey,
      };
}
