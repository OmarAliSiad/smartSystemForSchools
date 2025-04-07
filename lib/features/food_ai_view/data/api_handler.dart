import 'package:dio/dio.dart';

class DioHelper {
  Dio dio = Dio(
    BaseOptions(
      validateStatus: (_) => true,
      receiveDataWhenStatusError: true,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return dio.get(
      url,
      queryParameters: query,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
  }
}
