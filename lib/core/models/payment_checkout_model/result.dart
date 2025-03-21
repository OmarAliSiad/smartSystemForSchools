class Result {
  String? sessionId;
  String? pubKey;
  String? sessionUrl;

  Result({this.sessionId, this.pubKey, this.sessionUrl});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        sessionId: json['sessionId'] as String?,
        pubKey: json['pubKey'] as String?,
        sessionUrl: json['sessionUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'pubKey': pubKey,
        'sessionUrl': sessionUrl,
      };
}
