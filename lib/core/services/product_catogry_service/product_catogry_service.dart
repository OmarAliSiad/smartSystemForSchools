import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/catogry_details/catgory_details.dart';
import '../../models/get_all_products/get_all_products.dart';
import '../../utils/Constants.dart';

class ProductAndCatogryService {
  final Dio dio = Dio();

  Future<CatgoryDetails> getAllCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
        return CatgoryDetails(); // Return empty product details
      }
      final response = await dio.get(
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

  Future<GetAllProducts> getAllProducts({int? catogrydIdFilter}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.token);
      if (token == null) {
        log('No auth token found');
        return GetAllProducts(); // Return empty product details
      }
      final response = await dio.get(
        'https://school-api.runasp.net/api/Canteen/Product/GetAll',
        queryParameters: {
          'CategoryId': catogrydIdFilter,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      log('products status code : ${response.statusCode}');
      log('products headers: ${response.headers}');
      log('products API Response: ${response.data}');
      return GetAllProducts.fromJson(response.data);
    } catch (e) {
      log('Error fetching products: $e');
      return GetAllProducts(); // Return empty product details on error
    }
  }
}
