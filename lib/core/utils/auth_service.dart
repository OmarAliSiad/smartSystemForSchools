import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import '../../features/login/data/models/user_info_model.dart';

class AuthService {
  // Base URL of your API
  // Key for storing the token in SharedPreferences
  static const String _tokenKey = 'token';
  // Dio instance
  final Dio _dio = Dio();
  // Method to log in the user
  Future<Response> login({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        log('login');
        final responseData = response.data;
        final token = responseData['token'];
        await _saveToken(token);
        return response;
      } else {
        log('Login failed: ${response.statusCode}');
        return response;
      }
    } on DioException catch (e) {
      log('failed');
      log(
        e.message.toString(),
      );
      return e.response!;
    }
  }

  // Method to register a new user
  Future<Response> register({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final Response response;
    try {
      response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        final token = responseData['token'];
        await _saveToken(token);
        return response;
      } else {
        log('Registration failed: ${response.statusCode}');
        return response;
      }
    } on DioException catch (e) {
      log('Error during registration: $e');
      return e.response!;
    }
  }

  // Method to log out the user
  Future<void> logout() async {
    // Remove the token from SharedPreferences
    await _removeToken();
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // Method to get the stored token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Method to save the token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Method to remove the token from SharedPreferences
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    String token = prefs.getString(Constants.token) ?? '';
    log('token after removed ${(token).isEmpty} ');
  }

  // Method to get the token for authenticated requests
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> setUser({
    required UserInfoModel userModel,
  }) async {
    log('user is set in local storage');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.username, userModel.username!);
    log(userModel.username.toString());
    prefs.setString(Constants.email, userModel.email!);
    prefs.setString(Constants.token, userModel.token!);
    prefs.setString(Constants.id, userModel.userId!);
    prefs.setString(Constants.schoolTenantId, userModel.schoolTenantId!);
    prefs.getString(Constants.schoolTenantId)!;
    prefs.setStringList(Constants.roles,
        userModel.roles?.map((e) => e.toString()).toList() ?? []);
    prefs.setBool(Constants.isAuthenticated, userModel.isAuthenticated!);
  }

  Future<UserInfoModel> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(
      Constants.username,
    );
    String? email = prefs.getString(Constants.email);
    String? schoolTenantId = prefs.getString(Constants.schoolTenantId);
    String? userId = prefs.getString(Constants.userId);
    // String? roles = prefs.getString('roles');
    log('get school tenant id :');
    log(schoolTenantId.toString());
    return UserInfoModel(
      username: name,
      email: email,
      schoolTenantId: schoolTenantId,
      userId: userId,
    );
  }
}
