// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:e_square_ott_app/feature/home/controller/home_controller.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────
// Background message handler — MUST be a top-level function.
// Called when the app is terminated or in background.
// ─────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('[FCM] Background message received: ${message.messageId}');
    print('[FCM] Title: ${message.notification?.title}');
    print('[FCM] Body : ${message.notification?.body}');
    print('[FCM] Data : ${message.data}');

    final title =
        message.notification?.title ??
        message.data['title'] ??
        message.data['heading'] ??
        message.data['name'] ??
        'E-Square OTT';
    final body =
        message.notification?.body ??
        message.data['body'] ??
        message.data['message'] ??
        message.data['description'] ??
        '';

    if (title.isNotEmpty || body.isNotEmpty) {
      final localNotifications = FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInitSettings =
          DarwinInitializationSettings();
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );
      await localNotifications.initialize(settings: initSettings);

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      await localNotifications.show(
        id: message.hashCode,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  } catch (e) {
    print('[FCM] Error in background handler: $e');
  }
}

// ─────────────────────────────────────────────────────────────
// NotificationService
// ─────────────────────────────────────────────────────────────
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static Future<void> Function(RemoteMessage) get backgroundHandler =>
      firebaseMessagingBackgroundHandler;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final NotificationDatasource _datasource = NotificationDatasource();

  Function(RemoteMessage)? onNotificationTapHandler;

  /// Notifies the rest of the app about incoming foreground messages.
  final ValueNotifier<RemoteMessage?> latestMessage = ValueNotifier(null);

  String? _lastRegisteredToken;

  // ── Initialization ──────────────────────────────────────────
  /// Call this once from [main()] after [Firebase.initializeApp()].
  static Future<void> initialize() => instance._initialize();

  Future<void> _initialize() async {
    try {
      // Request permissions (FCM)
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      print('[FCM] Authorization status: ${settings.authorizationStatus}');

      // Initialize Local Notifications
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInitSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            try {
              final Map<String, dynamic> data = jsonDecode(payload);
              _handleNotificationTap(
                RemoteMessage(data: Map<String, String>.from(data)),
              );
            } catch (e) {
              log('[FCM] Error decoding local notification tap payload: $e');
            }
          }
        },
      );

      // Request Android notification permission (Android 13+)
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      // Create High Importance channel for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // Set foreground notification presentation options for iOS
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      print('[FCM Service] Initializing FCM listeners & token fetch...');
      await _subscribeToToken();
      _listenForeground();
      _listenOnOpen();
    } catch (e) {
      print('[FCM Service] Initialization error: $e');
    }
  }

  // ── Token management ─────────────────────────────────────────
  Future<void> _subscribeToToken() async {
    try {
      final token = await _fcm.getToken();
      print('[FCM Service] Fetched FCM Device token: $token');
      if (token != null) {
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      print('[FCM Service] Error getting FCM token: $e');
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      print('[FCM Service] FCM Token refreshed: $newToken');
      await registerTokenWithBackend(newToken);
    });
  }

  Future<void> registerTokenWithBackend(String fcmToken) async {
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        print(
          '[FCM Service] Skipping backend registration — user not logged in yet.',
        );
        return;
      }

      if (_lastRegisteredToken == fcmToken) {
        print(
          '[FCM Service] Token already registered for current session, skipping duplicate call.',
        );
        return;
      }

      final success = await _datasource.savedFcm(fcmToken: fcmToken);

      if (success) {
        _lastRegisteredToken = fcmToken;
        print('[FCM Service] Token registered successfully on backend.');
      } else {
        print('[FCM Service] Backend token registration failed.');
      }
    } catch (e) {
      print('[FCM Service] Error registering token with backend: $e');
    }
  }

  Future<void> unregisterTokenFromBackend() async {
    try {
      final fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        await _datasource.deleteFcm(fcmToken: fcmToken);
        _lastRegisteredToken = null;
        print('[FCM Service] Token unregistered from backend.');
      }
    } catch (e) {
      print('[FCM Service] Error unregistering token from backend: $e');
    }
  }

  // ── Foreground messages ──────────────────────────────────────
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('[FCM] Foreground message received: ${message.messageId}');
      print(
        '[FCM] Title: ${message.notification?.title} | Body: ${message.notification?.body}',
      );
      print('[FCM] Data: ${message.data}');

      latestMessage.value = message;

      final title =
          message.notification?.title ??
          message.data['title'] ??
          message.data['heading'] ??
          message.data['name'] ??
          'E-Square OTT';
      final body =
          message.notification?.body ??
          message.data['body'] ??
          message.data['message'] ??
          message.data['description'] ??
          '';

      if (title.isNotEmpty || body.isNotEmpty) {
        _localNotifications.show(
          id: message.hashCode,
          title: title,
          body: body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              playSound: true,
              enableVibration: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }

      // Refresh unread count in HomeController if active
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchUnreadCount();
      }
    });
  }

  // ── Notification tap ─────────────────────────────────────────
  void _listenOnOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[FCM] onMessageOpenedApp: ${message.data}');
      _handleNotificationTap(message);
    });
  }

  /// Call this after [initialize()] from root widget
  /// to handle notifications that launched the app from terminated state.
  Future<void> checkInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print('[FCM] App launched from terminated state via notification.');
      _handleNotificationTap(initialMessage);
    }
  }

  // ── Deep-link routing ────────────────────────────────────────
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final contentId = data['contentId'] as String?;

    print('[FCM] Handling tap — type: $type, contentId: $contentId');

    // Call external handler if set
    onNotificationTapHandler?.call(message);
  }

  // ── Local Notification Helper ────────────────────────────────
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  // ── Public helpers ───────────────────────────────────────────
  Future<void> registerAfterLogin() async {
    await _subscribeToToken();
  }

  Future<String?> get deviceToken => _fcm.getToken();
}
