import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/core/services/notification_service/get_notificatoin_details/get_notificatoin_details.dart';
import 'package:smartsystemforschools/features/notification_view/data/models/notification_model/notification_model.dart';

class NotificationService {
  final Dio dio = Dio();
  Future<NotificationModel> getAllNotifications(
      {required FilterNotificationModel filterNotificationModel}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('no auth token');
      }
      final response = await dio.get(
        'https://school-api.runasp.net/api/Notification/GetAll?studentId=${filterNotificationModel.studentId}',
        queryParameters: {
          "studentId": filterNotificationModel.studentId,
          "date": filterNotificationModel.date,
          "status": filterNotificationModel.status,
          "title": filterNotificationModel.title,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      log('status code :${response.statusCode}');
      log('response headers :${response.headers}');
      log('response data:${response.data}');
      NotificationModel notificationModel =
          NotificationModel.fromJson(response.data);
      if (notificationModel.statusCode == 200) {
        log('get  all notifications done successfully');
        return notificationModel;
      } else {
        log('failed to get all notifications');
        return notificationModel;
      }
    } catch (e) {
      log('Error faild to get all notifications : $e');
      return NotificationModel(isSuccess: false, message: e.toString());
    }
  }

  Future<String> deleteNotification({required String notificationId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('no auth token');
      }
      Response response = await dio.delete(
        'https://school-api.runasp.net/api/Notification/DeleteNotification',
        queryParameters: {
          'notificationId': notificationId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      log('notification is deleted');
      log('status code :${response.statusCode}');
      log('response headers :${response.headers}');
      log('notification is deleted : response data:${response.data}');
      if (response.statusCode == 200) {
        log('delete notification done successfully');
        return response.data['message'];
      } else {
        return response.data['message'];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<GetNotificatoinDetails> getNotificationtDetails(
      {required String notificationId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('no auth token');
      }
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Notification/GetDetails',
        queryParameters: {
          'notificationId': notificationId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      log('status code :${response.statusCode}');
      log('response headers :${response.headers}');
      log('response data:${response.data}');
      GetNotificatoinDetails getNotificatoinDetails =
          GetNotificatoinDetails.fromJson(response.data);
      if (getNotificatoinDetails.statusCode == 200) {
        log('get  all notifications done successfully');
        return getNotificatoinDetails;
      } else {
        log('failed to get all notifications');
        return getNotificatoinDetails;
      }
    } catch (e) {
      log('Error faild to get all notifications : $e');
      return GetNotificatoinDetails(isSuccess: false, message: e.toString());
    }
  }
}

class FilterNotificationModel {
  final String studentId;
  final String? date;
  final int? status;
  final int? title;
  FilterNotificationModel(
      {required this.studentId, this.date, this.status, this.title});
}
