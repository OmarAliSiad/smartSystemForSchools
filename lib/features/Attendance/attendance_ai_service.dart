// import 'package:flutter/foundation.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// class AttendanceRecord {
//   final DateTime date;
//   final String status; // 'present', 'absent', 'late'

//   AttendanceRecord({
//     required this.date,
//     required this.status,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'date': date.toIso8601String(),
//       'status': status,
//     };
//   }
// }

// class AttendanceAIService {
//   Interpreter? _interpreter;
//   bool _isModelLoaded = false;

//   Future<void> loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/models/attendance_model.tflite');
//       _isModelLoaded = true;
//       debugPrint('Attendance AI model loaded successfully');
//     } catch (e) {
//       debugPrint('Error loading attendance AI model: $e');
//       _isModelLoaded = false;
//     }
//   }

//   bool get isModelLoaded => _isModelLoaded;

//   Future<Map<String, dynamic>> analyzeAttendancePattern(List<AttendanceRecord> records) async {
//     if (!_isModelLoaded || _interpreter == null) {
//       throw Exception('Model not loaded yet');
//     }

//     if (records.isEmpty) {
//       throw Exception('No attendance records provided');
//     }

//     // Extract features from attendance records
//     // In a real implementation, this would be more sophisticated
//     List<double> features = _extractAttendanceFeatures(records);

//     // Prepare input tensor
//     var input = Float32List.fromList(features).reshape([1, features.length]);

//     // Assuming model outputs 3 classes: normal, concerning, critical
//     var output = List.filled(1 * 3, 0.0).reshape([1, 3]);

//     // Run inference
//     _interpreter!.run(input, output);

//     // Process results
//     return {
//       'status': _getAttendanceStatus(output[0]),
//       'trend': _analyzeAttendanceTrend(records),
//       'risk_level': _getRiskLevel(output[0]),
//       'recommendations': _generateRecommendations(output[0], records),
//     };
//   }

//   List<double> _extractAttendanceFeatures(List<AttendanceRecord> records) {
//     // Count number of each status
//     int presentCount = 0;
//     int absentCount = 0;
//     int lateCount = 0;

//     for (var record in records) {
//       if (record.status == 'present') {
//         presentCount++;
//       } else if (record.status == 'absent') {
//         absentCount++;
//       } else if (record.status == 'late') {
//         lateCount++;
//       }
//     }

//     // Calculate attendance rate
//     double attendanceRate = records.isEmpty
//         ? 0
//         : presentCount / records.length;

//     // Calculate recent attendance (last 5 records)
//     List<AttendanceRecord> recentRecords = records.length <= 5
//         ? records
//         : records.sublist(records.length - 5);

//     int recentPresentCount = 0;
//     for (var record in recentRecords) {
//       if (record.status == 'present') {
//         recentPresentCount++;
//       }
//     }

//     double recentAttendanceRate = recentRecords.isEmpty
//         ? 0
//         : recentPresentCount / recentRecords.length;

//     // Return features array
//     return [
//       attendanceRate,
//       recentAttendanceRate,
//       presentCount.toDouble(),
//       absentCount.toDouble(),
//       lateCount.toDouble(),
//       records.length.toDouble(),
//     ];
//   }

//   String _getAttendanceStatus(List<double> probabilities) {
//     // Find index with highest probability
//     int maxIndex = 0;
//     double maxValue = probabilities[0];

//     for (int i = 1; i < probabilities.length; i++) {
//       if (probabilities[i] > maxValue) {
//         maxValue = probabilities[i];
//         maxIndex = i;
//       }
//     }

//     // Map index to status
//     switch (maxIndex) {
//       case 0:
//         return 'Normal';
//       case 1:
//         return 'Concerning';
//       case 2:
//         return 'Critical';
//       default:
//         return 'Unknown';
//     }
//   }

//   String _analyzeAttendanceTrend(List<AttendanceRecord> records) {
//     if (records.length < 10) {
//       return 'Insufficient data for trend analysis';
//     }

//     // Sort records by date
//     records.sort((a, b) => a.date.compareTo(b.date));

//     // Analyze first half vs second half
//     int halfLength = records.length ~/ 2;
//     List<AttendanceRecord> firstHalf = records.sublist(0, halfLength);
//     List<AttendanceRecord> secondHalf = records.sublist(halfLength);

//     double firstHalfAttendance = firstHalf.where((r) => r.status == 'present').length / firstHalf.length;
//     double secondHalfAttendance = secondHalf.where((r) => r.status == 'present').length / secondHalf.length;

//     double difference = secondHalfAttendance - firstHalfAttendance;

//     if (difference > 0.1) {
//       return 'Improving';
//     } else if (difference < -0.1) {
//       return 'Declining';
//     } else {
//       return 'Stable';
//     }
//   }

//   String _getRiskLevel(List<double> probabilities) {
//     double normalProb = probabilities[0];
//     double concerningProb = probabilities[1];
//     double criticalProb = probabilities[2];

//     if (criticalProb > 0.6) {
//       return 'High';
//     } else if (concerningProb > 0.6 || criticalProb > 0.3) {
//       return 'Medium';
//     } else {
//       return 'Low';
//     }
//   }

//   List<String> _generateRecommendations(List<double> probabilities, List<AttendanceRecord> records) {
//     String status = _getAttendanceStatus(probabilities);
//     String trend = _analyzeAttendanceTrend(records);

//     List<String> recommendations = [];

//     if (status == 'Normal' && trend == 'Stable') {
//       recommendations.add('Continue with current attendance patterns');
//       recommendations.add('Maintain good communication with teachers');
//     } else if (status == 'Concerning' || trend == 'Declining') {
//       recommendations.add('Schedule a parent-teacher meeting to discuss attendance');
//       recommendations.add('Establish a morning routine to ensure timely arrival');
//       recommendations.add('Consider checking for health issues affecting attendance');
//     } else if (status == 'Critical') {
//       recommendations.add('Immediate intervention required to address attendance issues');
//       recommendations.add('Meet with school counselor to develop an attendance improvement plan');
//       recommendations.add('Address underlying issues that may be causing absences');
//       recommendations.add('Consider academic support to catch up on missed material');
//     }

//     return recommendations;
//   }
// }
