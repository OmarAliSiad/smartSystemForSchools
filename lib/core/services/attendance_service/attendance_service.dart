import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/attendance_model/attendance_model.dart';
import '../../utils/Constants.dart';

class AttendanceService {
  final Dio dio = Dio();

  Future<dynamic> getAttendanceByParent({String? date}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token);
    if (token == null) {
      log('No auth token found');
    }
    try {
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Attendance/GetAttendanceByParent',
        queryParameters: {'date': date},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check if response is valid
      if (response.statusCode == null || response.statusCode! >= 400) {
        log("API returned error status: ${response.statusCode}");
      }

      // Check if response data is valid
      if (response.data == null) {
        log("API returned null data");
      }

      log("API Response: ${response.data}");

      if (response.data is Map<String, dynamic>) {
        if (response.data['result'] is String) {
          log('this means data is not map');
          return AttendanceModel(
            isSuccess: true,
            statusCode: 200,
            message: null,
            resultForVaction: response.data['result'],
          );
        }
        // Handle JSON response
        AttendanceModel attendanceModel =
            AttendanceModel.fromJson(response.data);
        if (attendanceModel.isSuccess == true) {
          return attendanceModel;
        } else {
          log("API returned unsuccessful response or empty result: ${attendanceModel.message}");
        }
      } else if (response.data is String) {
        // Handle plain string response
        log("API returned a message: ${response.data}");
        return AttendanceModel(
          statusCode: response.statusCode ?? 200,
          isSuccess: true,
          message: response.data,
          result: null,
        );
      } else {
        log("Unexpected response type: ${response.data.runtimeType}");
      }
    } catch (e) {
      log("Unexpected error in attendance: $e");
    }
    return null;
  }
}
