import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/features/payment_parent/data/models/parent_transcations/parent_transcations.dart';
import 'package:smartsystemforschools/features/payment_parent/data/models/student_transcations/parent_transctions_model.dart';

class PaymentTransactionsService {
  final Dio dio;
  PaymentTransactionsService({Dio? dio}) : dio = dio ?? Dio();

  Future<ChildTransactionsModel> fetchTransactions({
    String? date,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        return ChildTransactionsModel();
      }
      const url =
          'https://school-api.runasp.net/api/Parent/GetStudentTransactionsToParent';
      final headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      final params = <String, dynamic>{};
      if (date != null) {
        params['date'] = date;
      }

      final response = await dio.get(
        url,
        options: Options(headers: headers),
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        return ChildTransactionsModel.fromJson(response.data);
      } else {
        return ChildTransactionsModel(isSuccess: false);
      }
    } catch (e) {
      return ChildTransactionsModel(isSuccess: false, message: e.toString());
    }
  }

  Future<ParentTranscationsModel> fetchParentTransactions({String ?studentId,String? date}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        return ParentTranscationsModel();
      }
      const url =
          'https://school-api.runasp.net/api/Parent/GetParentToStudentTransactions';
      final response = await dio.get(
        queryParameters: {
          'studentId': studentId,
          'date': date,
        },
        url,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return ParentTranscationsModel.fromJson(response.data);
      } else {
        return ParentTranscationsModel(isSuccess: false,message: 'Error fetching data');
      }
    } catch (e) {
      return ParentTranscationsModel(isSuccess: false, message: e.toString());
    }
  }
}
