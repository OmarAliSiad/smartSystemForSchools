import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/allegries_products/allegries_products.dart';
import '../../models/allegry_details/allegry_details.dart';
import '../../utils/Constants.dart';

class AllergiesService {
  Dio dio = Dio();
  Future<AllegryCatogryDetails> assingAllegrisCatogries(
      String studentId, int allergiesCategory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.post(
        'https://school-api.runasp.net/api/Parent/AssignAllergies',
        queryParameters: {
          'studentId': studentId,
          'allergiesCategory': allergiesCategory,
        },
        options: Options(
            validateStatus: (status) => status != null && status < 500,
            headers: {
              'accept': '*/*',
              'Authorization': 'Bearer $token',
            }),
      );
      if (response.statusCode == 200) {
        log('assing allegris');
        AllegryCatogryDetails allegryDetails =
            AllegryCatogryDetails.fromJson(response.data);
        return allegryDetails;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegryCatogryDetails(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegryCatogryDetails(message: 'Error fetching allergies: $e');
    }
  }

  Future<AllegriesProducts> assignProductAllergies(
      {required String studentId,
      required List<String> allergiesProducts}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.post(
        'https://school-api.runasp.net/api/Parent/AssignProductAllergies',
        queryParameters: {
          'studentId': studentId,
          'allergiesProducts': allergiesProducts,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('allegris products status code ${response.statusCode}');
      log('allegris products response  ${response.data}');
      log('allegris products headers ${response.headers}');
      if (response.statusCode == 200) {
        AllegriesProducts allegriesProducts =
            AllegriesProducts.fromJson(response.data);
        return allegriesProducts;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegriesProducts(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegriesProducts(
        message: 'Error fetching allergies: $e',
      );
    }
  }

  Future<AllegriesProducts> getProductAllergies(
      {required String studentId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.get(
        'https://school-api.runasp.net/api/Parent/GetProductAllergies',
        queryParameters: {
          'studentId': studentId,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('allegris products status code ${response.statusCode}');
      log('allegris products response  ${response.data}');
      log('allegris products headers ${response.headers}');
      if (response.statusCode == 200) {
        AllegriesProducts allegriesProducts =
            AllegriesProducts.fromJson(response.data);
        return allegriesProducts;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegriesProducts(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegriesProducts(
        message: 'Error fetching allergies: $e',
      );
    }
  }

  Future<AllegryCatogryDetails> getAllegrisCatogries(String studentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.get(
          'https://school-api.runasp.net/api/Parent/GetAllergies?studentId=$studentId',
          options: Options(
            headers: {
              'accept': '*/*',
              'Authorization': 'Bearer $token',
            },
            validateStatus: (status) => status != null && status < 500,
          ));
      if (response.statusCode == 200) {
        AllegryCatogryDetails allegryDetails =
            AllegryCatogryDetails.fromJson(response.data);
        return allegryDetails;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegryCatogryDetails(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegryCatogryDetails(message: 'Error fetching allergies: $e');
    }
  }

  Future<AllegryCatogryDetails> deleteAllegrisCatogries(
      String studentId, int allergiesCategory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.delete(
        'https://school-api.runasp.net/api/Parent/RemoveAllergies',
        queryParameters: {
          'studentId': studentId,
          'allergiesCategory': allergiesCategory,
        },
        options: Options(
            validateStatus: (status) => status != null && status < 500,
            headers: {
              'accept': '*/*',
              'Authorization': 'Bearer $token',
            }),
      );
      if (response.statusCode == 200) {
        log('assing allegris');
        AllegryCatogryDetails allegryDetails =
            AllegryCatogryDetails.fromJson(response.data);
        return allegryDetails;
      } else {
        log('Failed to delete allergies: ${response.statusCode}');
        return AllegryCatogryDetails(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegryCatogryDetails(message: 'Error fetching allergies: $e');
    }
  }

  Future<AllegriesProducts> removeProductAllergies(
      {required String studentId,
      required List<String> allergiesProducts}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      final response = await dio.delete(
        'https://school-api.runasp.net/api/Parent/RemoveProductAllergies',
        queryParameters: {
          'studentId': studentId,
          'allergiesProducts': allergiesProducts,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('removeProductAllergies status code ${response.statusCode}');
      log('removeProductAllergies response  ${response.data}');
      log('removeProductAllergies headers ${response.data}');
      if (response.statusCode == 200) {
        AllegriesProducts allegriesProducts =
            AllegriesProducts.fromJson(response.data);
        return allegriesProducts;
      } else {
        return AllegriesProducts(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegriesProducts(
        message: 'Error fetching allergies: $e',
      );
    }
  }
}
