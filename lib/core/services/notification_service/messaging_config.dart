// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:smartsystemforschools/core/services/notification_service/send_notification_services.dart';
// import 'package:smartsystemforschools/main.dart';

// class MessagingConfig {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       // sound: RawResourceAndroidNotificationSound('custom_sound'),
//       importance: Importance.max,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   static Future<void> initFirebaseMessaging() async {
//     await createNotificationChannel();
//     FirebaseMessaging.instance.getToken().then((fcmToken) {
//       log('fcmToken $fcmToken');
//     });
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse payload) {
//         log("payload1: ${payload.payload.toString()}");
//         return;
//       },
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       log('User granted provisional permission');
//     } else {
//       log('User declined or has not accepted permission');
//     }

//     FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
//       log("message received");
//       try {
//         RemoteNotification? notification = event.notification;
//         AndroidNotification? android = event.notification?.android;
//         log(notification!.body.toString());
//         log(notification.title.toString());

//         var body = notification.body;

//         await flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'high_importance_channel',
//               'High Importance Notifications',
//               channelDescription:
//                   'This channel is used for important notifications.',
//               icon: '@mipmap/ic_launcher',
//             ),
//             iOS: DarwinNotificationDetails(
//               presentAlert: true,
//               presentBadge: true,
//               presentSound: true,
//             ),
//           ),
//         );
//         // Use the global navigatorKey from main.dart
//         handleNotification(navigatorKey.currentContext!, event.data);
//       } catch (err) {
//         log(err.toString());
//       }
//     });

//     // Only handle notification when user clicks
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       handleNotification(navigatorKey.currentContext!, message.data);
//     });

//     // Also handle initial message when app is opened from a terminated state
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null) {
//         handleNotification(navigatorKey.currentContext!, message.data);
//       }
//     });
//   }

//   @pragma('vm:entry-point')
//   static Future<void> messageHandler(RemoteMessage message) async {
//     log('background message ${message.notification!.body}');
//   }
// }
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartsystemforschools/core/services/fcm_token_service/fcm_token_service.dart';
import 'package:smartsystemforschools/core/services/notification_service/send_notification_services.dart';
import 'package:smartsystemforschools/core/utils/AppNavigatorKeys.dart';

class MessagingConfig {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Get the navigator key from the singleton
  static final appNavigatorKeys = AppNavigatorKeys();

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> initFirebaseMessaging(
      {String? userId, String? studentId}) async {
    await createNotificationChannel();

    // Get and save the FCM token
    await FCMTokenService().saveToken();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        log("payload1: ${payload.payload.toString()}");
        return;
      },
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      log("message received");
      try {
        RemoteNotification? notification = event.notification;
        AndroidNotification? android = event.notification?.android;
        log(notification!.body.toString());
        log(notification.title.toString());

        var body = notification.body;

        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );

        // Use the shared navigator key from AppNavigatorKeys
        final context = appNavigatorKeys.mainNavigatorKey.currentContext;
        if (context != null) {
          handleNotification(context, event.data);
        }
      } catch (err) {
        log(err.toString());
      }
    });

    // Only handle notification when user clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final context = appNavigatorKeys.mainNavigatorKey.currentContext;
      if (context != null) {
        handleNotification(context, message.data);
      }
    });

    // Also handle initial message when app is opened from a terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        final context = appNavigatorKeys.mainNavigatorKey.currentContext;
        if (context != null) {
          handleNotification(context, message.data);
        }
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> messageHandler(RemoteMessage message) async {
    log('background message ${message.notification!.body}');
  }
}
