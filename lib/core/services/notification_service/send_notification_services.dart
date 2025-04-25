import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:smartsystemforschools/core/services/notification_service/confirmation_request_screen.dart';
import 'package:smartsystemforschools/core/services/notification_service/notification_details_screen.dart';
import 'package:smartsystemforschools/core/services/notification_service/notification_model.dart';

Future<String> getAccessToken() async {
  final jsonString = await rootBundle.loadString(
    'assets/notifications_key/notification-388f1-994027564a29.json',
  );

  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(jsonString);

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  return client.credentials.accessToken.data;
}

Future<void> sendNotification(
    {required String token,
    required String title,
    required String body,
    required Map<String, dynamic> data}) async {
  final String accessToken = await getAccessToken();
  const String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/notification-388f1/messages:send';

  final response = await http.post(
    Uri.parse(fcmUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(<String, dynamic>{
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data, // Add custom data here
        'android': {
          'notification': {
            // "sound": "custom_sound",
            'click_action':
                'FLUTTER_NOTIFICATION_CLICK', // Required for tapping to trigger response
            'channel_id': 'high_importance_channel'
          },
        },
        'apns': {
          'payload': {
            'aps': {/*"sound": "custom_sound.caf",*/ 'content-available': 1},
          },
        },
      },
    }),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}

void handleNotification(BuildContext context, Map<String, dynamic> data) {
  NotificationProductModel productModel =
      NotificationProductModel.fromJson(data); // Deserialize the JSON data
  String route = productModel.route;
  if (route == ConfirmationRequestScreen.id) {
    // Parse product details from the notification
    List<dynamic> products = jsonDecode(data['productDetails']);
    // Navigate to the confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationRequestScreen(
          pendingTransactionId: data['pendingTransactionId'],
          studentId: data['studentId'],
          studentName: data['studentName'],
          amountOfMoney: data['amountOfMoney'],
          products: products,
        ),
      ),
    );
  } else if (route == NotificationDetails.id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetails(
          notificationModel: productModel,
        ),
      ),
    );
  }
}
