import 'student_transaction_item.dart';

class ResultForNotificationDetails {
  String? id;
  double? moneyAmountSpended;
  String? studentId;
  String? studentName;
  String? cashierId;
  String? cashierName;
  DateTime? createdOn;
  String? schoolTenantId;
  List<StudentTransactionItem>? studentTransactionItems;

  ResultForNotificationDetails({
    this.id,
    this.moneyAmountSpended,
    this.studentId,
    this.studentName,
    this.cashierId,
    this.cashierName,
    this.createdOn,
    this.schoolTenantId,
    this.studentTransactionItems,
  });

  factory ResultForNotificationDetails.fromJson(Map<String, dynamic> json) => ResultForNotificationDetails(
        id: json['id'] as String?,
        moneyAmountSpended: json['moneyAmountSpended'] as double?,
        studentId: json['studentId'] as String?,
        studentName: json['studentName'] as String?,
        cashierId: json['cashierId'] as String?,
        cashierName: json['cashierName'] as String?,
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn'] as String),
        schoolTenantId: json['schoolTenantId'] as String?,
        studentTransactionItems:
            (json['studentTransactionItems'] as List<dynamic>?)
                ?.map((e) =>
                    StudentTransactionItem.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'moneyAmountSpended': moneyAmountSpended,
        'studentId': studentId,
        'studentName': studentName,
        'cashierId': cashierId,
        'cashierName': cashierName,
        'createdOn': createdOn?.toIso8601String(),
        'schoolTenantId': schoolTenantId,
        'studentTransactionItems':
            studentTransactionItems?.map((e) => e.toJson()).toList(),
      };
}
