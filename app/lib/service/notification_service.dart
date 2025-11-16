// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   // Singleton pattern
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   /// Initialize Firebase Messaging & Local Notifications
//   Future<void> init() async {
//     // Initialize Firebase if not already
//     await Firebase.initializeApp();

//     // Request permission
//     await _requestPermission();

//     // Initialize local notifications
//     await _initLocalNotifications();

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen(_onMessageHandler);

//     // Optional: handle when user taps notification
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
//   }

//   /// Background message handler
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     debugPrint(
//         'Handling a background message: ${message.messageId}, title: ${message.notification?.title}');
//   }

//   /// Request notification permission (iOS & Android 13+)
//   Future<void> _requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     debugPrint('User granted permission: ${settings.authorizationStatus}');
//   }

//   /// Initialize Flutter Local Notifications
//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iOSSettings,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   /// Handle foreground messages
//   void _onMessageHandler(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'todo_channel', // channel id
//             'ToDo Notifications', // channel name
//             channelDescription: 'Channel for ToDo app notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: const DarwinNotificationDetails(),
//         ),
//       );
//     }
//   }

//   /// Handle when user taps a notification
//   void _onMessageOpenedApp(RemoteMessage message) {
//     debugPrint('Notification clicked: ${message.notification?.title}');
//     // You can navigate to a screen here, e.g.,
//     // Navigator.of(context).push(MaterialPageRoute(builder: (_) => TaskScreen()));
//   }

//   /// Get device token (for testing push notifications)
//   Future<String?> getDeviceToken() async {
//     return await FirebaseMessaging.instance.getToken();
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
      'Handling a background message: ${message.messageId}, title: ${message.notification?.title}');
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> init() async {
    // Initialize Firebase if not already
    await Firebase.initializeApp();

    // Request notification permission (iOS & Android 13+)
    await _requestPermission();

    // Initialize local notifications
    await _initLocalNotifications();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    // Optional: handle when user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Print FCM device token
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Device Token: $token');
  }

  /// Request notification permission (iOS & Android 13+)
  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  /// Initialize Flutter Local Notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Handle foreground messages
  void _onMessageHandler(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'todo_channel', // channel id
            'ToDo Notifications', // channel name
            channelDescription: 'Channel for ToDo app notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }

  /// Handle notification tap
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification clicked: ${message.notification?.title}');
    // Optional: Navigate to a screen
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => TaskScreen()));
  }

  /// Get device token for testing
  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
