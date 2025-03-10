class Attendance {
  String? id;
  String? attendanceDate;
  String? leavingDate;

  Attendance({this.id, this.attendanceDate, this.leavingDate});

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json['id'] as String?,
        attendanceDate: json['attendanceDate'] as String?,
        leavingDate: json['leavingDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'attendanceDate': attendanceDate,
        'leavingDate': leavingDate,
      };
}
