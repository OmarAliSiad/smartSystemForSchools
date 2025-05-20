import 'package:dio/dio.dart';
import 'Constants.dart';
import 'api_keys.dart';

class PaymobService {
  // Singleton Dio instance
  final Dio _dio = Dio();

  Future<String> getPaymentKey(
      {required int amount, required String currency}) async {
    String authToken = await _retryRequest(() => _getAuthToken());
    int orderId = await _retryRequest(() => _getOrderId(
          authToken: authToken,
          amount: (amount * 100).toString(),
          currency: currency,
        ));
    String paymentKey = await _retryRequest(() => _getPaymentKey(
          authToken: authToken,
          orderId: orderId.toString(),
          amount: (amount * 100).toString(),
          currency: currency,
        ));
    return paymentKey;
  }

  // Retry logic with exponential backoff
  Future<T> _retryRequest<T>(Future<T> Function() request,
      {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await request();
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 && i < retries - 1) {
          await Future.delayed(
              Duration(seconds: 2 * (i + 1))); // Exponential backoff
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Failed after $retries retries');
  }

  // Get authentication token
  Future<String> _getAuthToken() async {
    try {
      final Response response = await _dio.post(
        'https://accept.paymob.com/api/auth/tokens',
        data: {
          'api_key': ApiKeys.paymobApiKeys,
        },
      );
      print('Auth Token Response: ${response.data}');
      return response.data['token'];
    } on DioException catch (e) {
      print('Error getting auth token: ${e.response?.data}');
      rethrow;
    }
  }

  // Get order ID
  Future<int> _getOrderId({
    required String authToken,
    required String amount,
    required String currency,
  }) async {
    try {
      final Response response = await _dio.post(
        'https://accept.paymob.com/api/ecommerce/orders',
        data: {
          'auth_token': authToken,
          'amount_cents': amount, // Use dynamic amount
          'currency': currency,
          'delivery_needed': 'false',
          'items': [],
        },
      );
      print('Order ID Response: ${response.data}');
      return response.data['id'];
    } on DioException catch (e) {
      print('Error getting order ID: ${e.response?.data}');
      rethrow;
    }
  }

  // Get payment key
  Future<String> _getPaymentKey({
    required String authToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    try {
      final Response response = await _dio.post(
        'https://accept.paymob.com/api/acceptance/payment_keys',
        data: {
          "expiration": 3600,
          "auth_token": authToken, // From First API
          "order_id": orderId, // From Second API
          "integration_id":
              Constants.intergrationId, // Integration ID of the payment method
          "amount_cents": amount,
          "currency": currency,
          "billing_data": {
            // Required values
            "first_name": "Clifford",
            "last_name": "Nicolas",
            "email": "claudette09@exa.com",
            "phone_number": "+86(8)9135210487",

            // Optional values (can set "NA")
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "state": "NA",
          },
        },
      );
      print('Payment Key Response: ${response.data}');
      return response.data['token'];
    } on DioException catch (e) {
      print('Error getting payment key: ${e.response?.data}');
      rethrow;
    }
  }
}
