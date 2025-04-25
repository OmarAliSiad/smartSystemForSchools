import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/models/get_balance/get_balance.dart';
import 'package:smartsystemforschools/core/models/money_recharge_model/money_recharge_model.dart';
import 'package:smartsystemforschools/core/models/parent_to_stuent_transcation/parent_to_stuent_transcation.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/models/get_sending_limit/get_sending_limit.dart';

class PaymentService {
  final Dio dio = Dio();

  Future<MoneyRechargeModel> moneyRecharge({
    required String studentId,
    required double amount,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      log(studentId.toString());
      log((amount is double).toString());
      log(amount.toString());
      try {
        Response response = await dio.post(
          'https://school-api.runasp.net/api/Parent/MoneyRecharge',
          data: {
            "moneyAmount": amount,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );
        log('Status code: ${response.statusCode}');
        log('Headers: ${response.headers}');
        log('response.data: ${response.data}');
        // Handle server error (500) explicitly
        if (response.statusCode == 500) {
          return MoneyRechargeModel(
            statusCode: 500,
            isSuccess: false,
            message: response.data['Message'],
          );
        }

        MoneyRechargeModel moneyRechargeModel =
            MoneyRechargeModel.fromJson(response.data);
        log('Payment checkout response: ${moneyRechargeModel.toJson().toString()}');
        return moneyRechargeModel;
      } on DioException catch (e) {
        log('DioException during payment checkout: ${e.message}');
        return MoneyRechargeModel(
          statusCode: e.response?.statusCode ?? 0,
          isSuccess: false,
          message: 'Network error: ${e.message}',
        );
      }
    } catch (e) {
      log("Unexpected exception when checkout payment for child: $e");
      return MoneyRechargeModel(
        statusCode: 0,
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<GetBalance> getBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Parent/GetBalance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('Status code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('response.data: ${response.data}');
      GetBalance getBalance = GetBalance.fromJson(response.data);
      return getBalance;
    } catch (e) {
      log("Error in getBalance: $e");
      return GetBalance(
        statusCode: 0,
        isSuccess: false,
        message: 'An error occurred while fetching balance: $e',
      );
    }
  }

  Future<ParentToStuentTranscation> setMoneyForStudent({
    required String studentId ,required  double amountOfMoney,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      Response response = await dio.post(
        'https://school-api.runasp.net/api/Parent/ParentToStudentMoneyRecharge',
        data: {"studentId": studentId, "amountOfMoney": amountOfMoney},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('Status code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('response.data: ${response.data}');
      ParentToStuentTranscation parentToStuentTranscation =
          ParentToStuentTranscation.fromJson(response.data);
      return parentToStuentTranscation;
    } catch (e) {
      log("Error in getBalance: $e");
      return ParentToStuentTranscation(
        statusCode: 0,
        isSuccess: false,
        message: 'An error occurred while fetching balance: $e',
      );
    }
  }

  Future<GetSendingLimit> getSpenddingLimit({
    required String studentId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Parent/GetSpendingLimit',
        queryParameters: {
          "studentId": studentId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('Status code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('response.data: ${response.data}');
      if (response.statusCode == 500) {
        return GetSendingLimit(
          statusCode: 500,
          isSuccess: false,
          message: response.data['message'],
        );
      }
      GetSendingLimit spenddingLimit = GetSendingLimit.fromJson(response.data);
      if (spenddingLimit.isSuccess == true) {
        return spenddingLimit;
      } else {
        throw Exception(spenddingLimit.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> addSpendingLimit({
    required String studentId,
    double? dailySpendingLimit,
    double? weeklySpendingLimit,
    double? monthlySpendingLimit,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }

      // Create payload with explicit null values when needed
      Map<String, dynamic> payload = {
        "studentId": studentId,
        "dailySpendingLimit": dailySpendingLimit,
        "weeklySpendingLimit": weeklySpendingLimit,
        "monthlySpendingLimit": monthlySpendingLimit
      };

      // Log the actual payload being sent
      log('Sending payload: $payload');

      Response response = await dio.post(
        'https://school-api.runasp.net/api/Parent/AddSpendingLimit',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log('Status code: ${response.statusCode}');
      log('Response data: ${response.data}');
      return response;
    } catch (e) {
      log('Error in addSpendingLimit: $e');
      return Response(requestOptions: RequestOptions(path: ''), data: {
        'message': 'An error occurred while adding spending limit: $e'
      });
    }
  }
}
