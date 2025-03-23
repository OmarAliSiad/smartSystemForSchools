import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/models/get_school_details_by_id/get_school_details_by_id.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/models/get_sending_limit/get_sending_limit.dart';
import '../models/get_all_schools/get_all_schools.dart';
import '../models/get_child_details/result.dart';

class SchoolService {
  final Dio dio = Dio();

  Future<GetAllSchools?> getAllSchools({
    String? countryName,
  }) async {
    try {
      // Attempt to call the API
      try {
        Response response = await dio.get(
          'https://school-api.runasp.net/api/School/GetAll',
          queryParameters: {'country': countryName},
        );

        // Check if response is valid
        if (response.statusCode == null || response.statusCode! >= 400) {
          log("API returned error status: ${response.statusCode}");
        }

        // Check if response data is valid
        if (response.data == null) {
          log("API returned null data");
        }

        try {
          // Parse the response data
          GetAllSchools getAllSchools = GetAllSchools.fromJson(response.data);
          log(getAllSchools.toJson().toString());

          // Check if the parsed data is valid
          if (getAllSchools.isSuccess == true &&
              getAllSchools.result != null &&
              getAllSchools.result!.isNotEmpty) {
            return getAllSchools;
          } else {
            log("API returned unsuccessful response or empty result: ${getAllSchools.message}");
          }
        } catch (parseError) {
          log("Error parsing API response: $parseError");
        }
      } catch (apiError) {
        // If API call fails, return mock data
        log("API call failed, using mock data: $apiError");
      }
    } catch (e) {
      log("Unexpected error in getAllSchools: $e");
      // Even if mock data creation fails, we should return something valid
    }
    return null;
  }

  Future<SchoolDetails> getSchoolById(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      Response response = await dio.get(
        'https://school-api.runasp.net/api/School/GetById/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      SchoolDetails schoolDetails = SchoolDetails.fromJson(response.data);
      log(schoolDetails.toString());
      if (schoolDetails.isSuccess == true) {
        return schoolDetails;
      } else {
        throw Exception(schoolDetails.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> addChild({required String id}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
        return {
          'isSuccess': false,
          'message': 'Authentication token not found'
        };
      }
      log('Attempting to add child with ID: $id');
      log('Request URL: https://school-api.runasp.net/api/Parent/AddChild/$id');
      Response response = await dio.post(
        'https://school-api.runasp.net/api/Parent/AddChild/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Add if required
          },
        ),
      );
      log('Response status code: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 404) {
        return {'isSuccess': false, 'message': 'API endpoint not found'};
      }

      if (response.statusCode == 400) {
        String errorMessage = 'Bad request: ';
        if (response.data is Map<String, dynamic>) {
          errorMessage += response.data['message'] ?? 'Invalid request data';
        } else {
          errorMessage += 'Please check your input and try again';
        }
        log('Bad request details: ${response.data}'); // Log full response
        return {'isSuccess': false, 'message': errorMessage};
      }

      if (response.statusCode! >= 400) {
        String errorMessage = '';
        if (response.data is Map<String, dynamic>) {
          errorMessage = response.data['message'] ?? 'Unknown error occurred';
        } else {
          errorMessage = 'Error adding child: ${response.statusCode}';
        }
        return {'isSuccess': false, 'message': errorMessage};
      }

      if (response.data != null && response.data is Map<String, dynamic>) {
        return {
          'isSuccess': response.data['isSuccess'] ?? false,
          'message': response.data['message'] ?? 'Operation completed'
        };
      }

      return {
        'isSuccess': false,
        'message': 'Invalid response format from server'
      };
    } on DioException catch (e) {
      log("DioException when adding child: ${e.message}");
      String errorMessage = '';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message'] ??
            e.message ??
            'Network error occurred';
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }
      return {'isSuccess': false, 'message': errorMessage};
    } catch (e) {
      log("Unexpected exception when adding child: $e");
      return {
        'isSuccess': false,
        'message': 'An unexpected error occurred: $e'
      };
    }
  }

  Future<ResultForChildDetails> getChildDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
      }
      log('entered in getChildDetails');
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Parent/GetChilds',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      // Check if response is valid
      if (response.statusCode == null || response.statusCode! >= 400) {
        log("API returned error status when getting child details: ${response.statusCode}");
        throw Exception(
            "Failed to get child details. Server returned status: ${response.statusCode}");
      }

      // Check if response data is valid
      if (response.data == null) {
        log("API returned null data for child details");
        throw Exception(
            "Failed to get child details. Server returned empty data.");
      }

      try {
        ResultForChildDetails resultForChildDetails =
            ResultForChildDetails.fromJson(response.data);
        log(resultForChildDetails.toString());
        return resultForChildDetails;
      } catch (parseError) {
        log("Error parsing child details response: $parseError");
        throw Exception("Failed to parse child details data: $parseError");
      }
    } catch (e) {
      log("Exception when getting child details: $e");
      throw Exception("Failed to get child details: $e");
    }
  }

  Future<List<ResultForChildDetails>> getAllChildDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
        return [];
      }

      log('Getting all children details');
      Response response = await dio.get(
        'https://school-api.runasp.net/api/Parent/GetChilds',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      // Check if response is valid
      if (response.statusCode == null || response.statusCode! >= 400) {
        log("API returned error status when getting children details: ${response.statusCode}");
        return [];
      }

      // Check if response data is valid
      if (response.data == null) {
        log("API returned null data for children details");
        return [];
      }

      try {
        // Check if the response is a list
        if (response.data is List) {
          List<ResultForChildDetails> children = [];
          for (var childData in response.data) {
            children.add(ResultForChildDetails.fromJson(childData));
          }
          log("Retrieved ${children.length} children");
          return children;
        }
        // If it's a single object with a result field that contains a list
        else if (response.data is Map && response.data['result'] is List) {
          List<ResultForChildDetails> children = [];
          for (var childData in response.data['result']) {
            children.add(ResultForChildDetails.fromJson(childData));
          }
          log("Retrieved ${children.length} children from result field");
          return children;
        }
        // If it's a single child object
        else {
          ResultForChildDetails child =
              ResultForChildDetails.fromJson(response.data);
          log("Retrieved a single child: ${child.fullName}");
          return [child];
        }
      } catch (parseError) {
        log("Error parsing children details response: $parseError");
        return [];
      }
    } catch (e) {
      log("Exception when getting children details: $e");
      return [];
    }
  }

  Future<PaymentCheckoutModel> checkPaymentStatus({
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
          'https://school-api.runasp.net/api/Parent/Checkout',
          data: {
            "studentId": studentId.toString(),
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
          return PaymentCheckoutModel(
            statusCode: 500,
            isSuccess: false,
            message: response.data['Message'],
          );
        }

        PaymentCheckoutModel paymentCheckoutModel =
            PaymentCheckoutModel.fromJson(response.data);
        log('Payment checkout response: ${paymentCheckoutModel.toJson().toString()}');
        return paymentCheckoutModel;
      } on DioException catch (e) {
        log('DioException during payment checkout: ${e.message}');
        return PaymentCheckoutModel(
          statusCode: e.response?.statusCode ?? 0,
          isSuccess: false,
          message: 'Network error: ${e.message}',
        );
      }
    } catch (e) {
      log("Unexpected exception when checkout payment for child: $e");
      return PaymentCheckoutModel(
        statusCode: 0,
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
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
