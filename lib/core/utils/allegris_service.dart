import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/models/allegry_details/allegry_details.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import '../models/catogry_details/catgory_details.dart';

class AllergiesService {
  Dio dio = Dio();
  Future<AllegryDetails> assingAllegris(
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
        AllegryDetails allegryDetails = AllegryDetails.fromJson(response.data);
        return allegryDetails;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegryDetails(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegryDetails(message: 'Error fetching allergies: $e');
    }
  }

  Future<AllegryDetails> getAllegris(String studentId) async {
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
        AllegryDetails allegryDetails = AllegryDetails.fromJson(response.data);
        return allegryDetails;
      } else {
        log('Failed to load allergies: ${response.statusCode}');
        return AllegryDetails(message: response.data['message']);
      }
    } catch (e) {
      log('Error fetching allergies: $e');
      return AllegryDetails(message: 'Error fetching allergies: $e');
    }
  }

  Future<CatgoryDetails> getAllCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
        return CatgoryDetails(); // Return empty product details
      }
      final response = await Dio().get(
        'https://school-api.runasp.net/api/Canteen/Category/GetAll',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      log('catogry API Response: ${response.data}');
      return CatgoryDetails.fromJson(response.data);
    } catch (e) {
      log('Error fetching catogries: $e');
      return CatgoryDetails(); // Return empty product details on error
    }
  }
}
