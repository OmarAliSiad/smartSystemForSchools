class Result {
  String? id;
  String? status;
  String? title;
  String? message;
  DateTime? createdOn;

  Result({this.id, this.status, this.title, this.message, this.createdOn});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'] as String?,
        status: json['status'] as String?,
        title: json['title'] as String?,
        message: json['message'] as String?,
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'title': title,
        'message': message,
        'createdOn': createdOn?.toIso8601String(),
      };
}
