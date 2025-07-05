import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../generated/locale_keys.g.dart';
import '../../utils/Constants.dart';
import '../../widgets/show_dialog.dart';
import '../../../features/login/data/models/user_info_model.dart';

class AuthService {
  final Dio dio = Dio();
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

  Future<void> forgotPassword(
      {required BuildContext context, required String email}) async {
    try {
      Response response = await dio.post(
        'https://school-api.runasp.net/api/Account/forgotPassword',
        data: {
          "email": email,
          "clientUrl": "https://student-7e31f.web.app/reset-password",
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (context.mounted) {
          showAswemoDialog(
              dialogType: DialogType.success,
              context: context,
              title: LocaleKeys.showDialogLogin_info.tr(),
              desc: LocaleKeys.showDialogLogin_goToGmailAndResetYourPassword
                  .tr());
        }
      }
    } catch (e) {
      if (context.mounted) {
        showAswemoDialog(
          context: context,
          dialogType: DialogType.error,
          title: LocaleKeys.showDialogLogin_error.tr(),
          desc: e.toString(),
        );
      }
    }
  }

  // Method to log out the user
  Future<void> logout() async {
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

  // Method to check if the token is expired
  Future<bool> isTokenExpired() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      return true;
    }

    try {
      // Use JwtDecoder to check if token is expired
      return JwtDecoder.isExpired(token);
    } catch (e) {
      log('Error checking token expiration: $e');
      return true; // Consider token invalid if there's an error
    }
  }

  // Method to validate token and logout if expired
  Future<bool> validateTokenAndLogoutIfNeeded(BuildContext context) async {
    if (await isTokenExpired()) {
      await logout();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/login', // Replace with your actual login route name
            (route) => false);

        // Show expiration message
        showAswemoDialog(
          context: context,
          dialogType: DialogType.info,
          title: LocaleKeys.showDialogLogin_sessionExpired.tr(),
          desc: LocaleKeys.showDialogLogin_yourSessionHasExpiredPleaseLogInAgain
              .tr(),
        );
      }

      return false;
    }
    return true; // Token is valid
  }

  // Get token's remaining time in seconds
  Future<int> getTokenRemainingTime() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      return 0;
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      DateTime expiryDate = JwtDecoder.getExpirationDate(token);
      final remaining = expiryDate.difference(DateTime.now()).inSeconds;
      return remaining > 0 ? remaining : 0;
    } catch (e) {
      log('Error getting token expiration time: $e');
      return 0;
    }
  }

  // Updated getAuthHeaders with token validation
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _getToken();
    if (token == null || await isTokenExpired()) {
      log('Token is expired or null when trying to get auth headers');
    }
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

    // Validate username before saving
    if (userModel.username == null || userModel.username!.trim().isEmpty) {
      throw Exception('Username cannot be null or empty');
    }

    await prefs.setString(Constants.username, userModel.username!.trim());
    log('Saved username: ${userModel.username}');

    // Validate and save other user data
    if (userModel.email != null && userModel.email!.isNotEmpty) {
      prefs.setString(Constants.email, userModel.email!);
    }
    if (userModel.token != null && userModel.token!.isNotEmpty) {
      prefs.setString(Constants.token, userModel.token!);
    }
    if (userModel.userId != null && userModel.userId!.isNotEmpty) {
      prefs.setString(Constants.id, userModel.userId!);
    }
    if (userModel.schoolTenantId != null &&
        userModel.schoolTenantId!.isNotEmpty) {
      prefs.setString(Constants.schoolTenantId, userModel.schoolTenantId!);
    }

    prefs.setStringList(Constants.roles,
        userModel.roles?.map((e) => e.toString()).toList() ?? []);
    prefs.setBool(
        Constants.isAuthenticated, userModel.isAuthenticated ?? false);
  }

  Future<UserInfoModel> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(
      Constants.username,
    );
    String email = prefs.getString(Constants.email)!;
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
