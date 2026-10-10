import 'dart:convert';

import 'package:e_square_ott_app/feature/home/controller/home_controller.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    LogUtil.log(
      '[FCM] Background message received: ${message.messageId}',
      name: 'FCM',
    );
    LogUtil.log('[FCM] Title: ${message.notification?.title}', name: 'FCM');
    LogUtil.log('[FCM] Body : ${message.notification?.body}', name: 'FCM');
    LogUtil.log('[FCM] Data : ${message.data}', name: 'FCM');

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

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // Only show a local notification if Android FCM didn't automatically display one
    // (FCM automatically displays notifications with a 'notification' payload in background).
    if (message.notification == null && (title.isNotEmpty || body.isNotEmpty)) {
      await flutterLocalNotificationsPlugin.show(
        id: message.messageId?.hashCode ?? message.hashCode,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  } catch (e, stack) {
    LogUtil.error(
      '[FCM] Error in background handler: $e',
      name: 'FCM',
      error: e,
      stackTrace: stack,
    );
  }

}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final NotificationDatasource _datasource = NotificationDatasource();

  /// Observable for latest notification message received while app is running
  final Rxn<RemoteMessage> latestMessage = Rxn<RemoteMessage>();

  /// Callback registered by app for notification tap routing
  void Function(RemoteMessage message)? onNotificationTapHandler;

  String? _lastRegisteredToken;
  bool _isListenersSetup = false;
  final Set<String> _processedMessageIds = {};

  // ── Initialization ───────────────────────────────────────────
  static Future<void> initialize() async {
    await instance._initService();
  }


  Future<void> _initService() async {
    // 1. Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(androidChannel);

    // 2. Initialize local notifications plugin
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            _handleNotificationTap(RemoteMessage(data: data));
          } catch (e) {
            LogUtil.error(
              "[NotificationService] payload decode error: $e",
              name: "FCM",
            );
          }
        }
      },
    );

    // 3. Request permissions
    await _requestPermissions();

    // 4. Foreground presentation options for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Setup token listeners & FCM event listeners
    await _setupListeners();
  }

  // ── Request permissions ───────────────────────────────────────
  Future<bool> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    LogUtil.log(
      '[FCM] Authorization status: ${settings.authorizationStatus}',
      name: 'FCM',
    );

    // Also request for local notifications on Android 13+
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    return granted;
  }

  // ── Listeners ────────────────────────────────────────────────
  Future<void> _setupListeners() async {
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _subscribeToToken();

      if (!_isListenersSetup) {
        _isListenersSetup = true;
        LogUtil.log(
          '[FCM Service] Initializing FCM listeners & token fetch...',
          name: 'FCM',
        );
        _listenForeground();
        _listenOnOpen();
      }
    } catch (e, stack) {
      LogUtil.error(
        '[FCM Service] Initialization error: $e',
        name: 'FCM',
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Token management ─────────────────────────────────────────
  Future<void> _subscribeToToken() async {
    try {
      final token = await _fcm.getToken();
      LogUtil.log(
        '[FCM Service] Fetched FCM Device token: $token',
        name: 'FCM',
      );
      if (token != null) {
        await registerTokenWithBackend(token);
      }
    } catch (e, stack) {
      LogUtil.error(
        '[FCM Service] Error getting FCM token: $e',
        name: 'FCM',
        error: e,
        stackTrace: stack,
      );
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      LogUtil.log('[FCM Service] FCM Token refreshed: $newToken', name: 'FCM');
      await registerTokenWithBackend(newToken);
    });
  }

  Future<void> registerTokenWithBackend(String fcmToken) async {
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        LogUtil.log(
          '[FCM Service] Skipping backend registration — user not logged in yet.',
          name: 'FCM',
        );
        return;
      }

      if (_lastRegisteredToken == fcmToken) {
        LogUtil.log(
          '[FCM Service] Token already registered for current session, skipping duplicate call.',
          name: 'FCM',
        );
        return;
      }

      final success = await _datasource.savedFcm(fcmToken: fcmToken);

      if (success) {
        _lastRegisteredToken = fcmToken;
        LogUtil.info(
          '[FCM Service] Token registered successfully on backend.',
          name: 'FCM',
        );
      } else {
        LogUtil.warning(
          '[FCM Service] Backend token registration failed.',
          name: 'FCM',
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        '[FCM Service] Error registering token with backend: $e',
        name: 'FCM',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> unregisterTokenFromBackend() async {
    try {
      final fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        await _datasource.deleteFcm(fcmToken: fcmToken);
        _lastRegisteredToken = null;
        LogUtil.info(
          '[FCM Service] Token unregistered from backend.',
          name: 'FCM',
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        '[FCM Service] Error unregistering token from backend: $e',
        name: 'FCM',
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Foreground messages ──────────────────────────────────────
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final msgId = message.messageId ?? '${message.sentTime?.millisecondsSinceEpoch}_${message.data.hashCode}';
      if (_processedMessageIds.contains(msgId)) {
        LogUtil.log('[FCM] Skipping duplicate foreground message: $msgId', name: 'FCM');
        return;
      }
      _processedMessageIds.add(msgId);
      if (_processedMessageIds.length > 50) {
        _processedMessageIds.remove(_processedMessageIds.first);
      }

      LogUtil.log(
        '[FCM] Foreground message received: $msgId',
        name: 'FCM',
      );
      LogUtil.log(
        '[FCM] Title: ${message.notification?.title} | Body: ${message.notification?.body}',
        name: 'FCM',
      );
      LogUtil.log('[FCM] Data: ${message.data}', name: 'FCM');

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
          id: message.messageId?.hashCode ?? message.hashCode,
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
      LogUtil.log('[FCM] onMessageOpenedApp: ${message.data}', name: 'FCM');
      _handleNotificationTap(message);
    });
  }

  /// Call this after [initialize()] from root widget
  /// to handle notifications that launched the app from terminated state.
  Future<void> checkInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      LogUtil.log(
        '[FCM] App launched from terminated state via notification.',
        name: 'FCM',
      );
      _handleNotificationTap(initialMessage);
    }
  }

  // ── Deep-link routing ────────────────────────────────────────
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final contentId = data['contentId'] as String?;

    LogUtil.log(
      '[FCM] Handling tap — type: $type, contentId: $contentId',
      name: 'FCM',
    );

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
