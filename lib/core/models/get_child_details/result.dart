class ResultForChildDetails {
  String? id;
  String? fullName;
  String? gender;
  int? grade;
  String? city;
  String? street;
  String? birthDate;
  String? rfidTagId;
  DateTime? createdOn;
  double? amountOfMoney;
  // String? studentImage;
  String? schoolTenantId;

  ResultForChildDetails({
    this.id,
    this.fullName,
    this.gender,
    this.grade,
    this.city,
    this.street,
    this.birthDate,
    this.rfidTagId,
    this.createdOn,
    // this.studentImage,
    this.amountOfMoney,
    this.schoolTenantId,
  });

  factory ResultForChildDetails.fromJson(Map<String, dynamic> json) =>
      ResultForChildDetails(
        id: json['id'] as String?,
        fullName: json['fullName'] as String?,
        gender: json['gender'] as String?,
        grade: json['grade'] as int?,
        city: json['city'] as String?,
        street: json['street'] as String?,
        birthDate: json['birthDate'] as String?,
        rfidTagId: json['rfidTag_Id'] as String?,
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn'] as String),
        // studentImage: json['studentImage'] as String?,
        schoolTenantId: json['schoolTenantId'] as String?,
        amountOfMoney: json['amountOfMoney'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'gender': gender,
        'grade': grade,
        'city': city,
        'street': street,
        'birthDate': birthDate,
        'rfidTag_Id': rfidTagId,
        'createdOn': createdOn?.toIso8601String(),
        // 'studentImage': studentImage,
        'schoolTenantId': schoolTenantId,
        'amountOfMoney': amountOfMoney,
      };
}
