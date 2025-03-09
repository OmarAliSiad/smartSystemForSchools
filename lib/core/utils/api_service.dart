import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  Future<Response> post(
      {required String url,
      required Map<String, dynamic> body,
      String? token,
      required Map<String, String>? headers}) async {
    try {
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: headers ??
              {
                'Authorization': 'Bearer $token',
              },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      // Log response for debugging
      log('POST Response for $url: ${response.statusCode}');

      if (response.statusCode! >= 400) {
        log('Error response: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      log('DioException in POST request: ${e.message}');
      if (e.response != null) {
        log('Error status: ${e.response!.statusCode}');
        log('Error data: ${e.response!.data}');
        return e.response!;
      } else {
        // If there's no response (e.g., network error), create a mock response
        return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 503,
          data: {'message': 'Network error: ${e.message}'},
        );
      }
    }
  }

  Future<Response> get(
      {required String url,
      String? token,
      Map<String, String>? headers}) async {
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: headers ?? {'Authorization': 'Bearer $token'},
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      // Log response for debugging
      log('GET Response for $url: ${response.statusCode}');

      if (response.statusCode! >= 400) {
        log('Error response: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      log('DioException in GET request: ${e.message}');
      if (e.response != null) {
        log('Error status: ${e.response!.statusCode}');
        log('Error data: ${e.response!.data}');
        return e.response!;
      } else {
        // If there's no response (e.g., network error), create a mock response
        return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 503,
          data: {'message': 'Network error: ${e.message}'},
        );
      }
    }
  }
}
