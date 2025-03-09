import 'package:latlong2/latlong.dart';

class StudentLocation {
  final String studentId;
  final String studentName;
  final LatLng location;
  final DateTime timestamp;
  final bool isInsideGeofence;

  StudentLocation({
    required this.studentId,
    required this.studentName,
    required this.location,
    required this.timestamp,
    this.isInsideGeofence = false,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': timestamp.toIso8601String(),
        'isInsideGeofence': isInsideGeofence,
      };

  factory StudentLocation.fromJson(Map<String, dynamic> json) {
    return StudentLocation(
      studentId: json['studentId'],
      studentName: json['studentName'],
      location: LatLng(json['latitude'], json['longitude']),
      timestamp: DateTime.parse(json['timestamp']),
      isInsideGeofence: json['isInsideGeofence'] ?? false,
    );
  }
}
