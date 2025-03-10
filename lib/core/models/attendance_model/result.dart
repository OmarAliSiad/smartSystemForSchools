import 'attendance.dart';

class Result {
  String? id;
  String? fullName;
  String? gender;
  int? grade;
  String? city;
  String? street;
  String? birthDate;
  String? rfidTagId;
  DateTime? createdOn;
  List<Attendance>? attendances;

  Result({
    this.id,
    this.fullName,
    this.gender,
    this.grade,
    this.city,
    this.street,
    this.birthDate,
    this.rfidTagId,
    this.createdOn,
    this.attendances,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
        attendances: (json['attendances'] as List<dynamic>?)
            ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
            .toList(),
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
        'attendances': attendances?.map((e) => e.toJson()).toList(),
      };
}
