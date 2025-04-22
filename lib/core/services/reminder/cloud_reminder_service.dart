import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';

class CloudReminderService {
  late final FirebaseMessaging _firebaseMessaging;
  final StorageService _storageService;
  final NotificationService? _notificationService;

  CloudReminderService({
    StorageService? storageService,
    NotificationService? notificationService,
  }) : _storageService = storageService ?? serviceLocator<StorageService>(),
       _notificationService =
           notificationService ?? serviceLocator<NotificationService>() {
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  Future<void> initialize() async {
    try {
      final settings = await _requestNotificationPermissions();
      debugPrint('FCM permission settings: ${settings.authorizationStatus}');

      await _setupTokenHandling();
      _setupMessageHandlers();

      debugPrint('FCM initialized successfully');
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  Future<NotificationSettings> _requestNotificationPermissions() async {
    return _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _setupTokenHandling() async {
    final token = await _firebaseMessaging.getToken();

    if (token != null) {
      await _saveDeviceToken(token);
    } else {
      debugPrint('Error: FCM token is null');
    }

    _firebaseMessaging.onTokenRefresh.listen(_saveDeviceToken);
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _saveDeviceToken(String token) async {
    try {
      await _storageService.setString('fcm_token', token);
      debugPrint('FCM token saved locally: ${token.substring(0, 10)}...');

      final userData = await _storageService.getUserData();
      if (userData != null && userData['id'] != null) {
        debugPrint('FCM token saved for user: ${userData['id']}');
      }
    } catch (e) {
      debugPrint('Error in _saveDeviceToken: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('Got FCM message: ${message.notification?.title}');

    try {
      if (_notificationService == null) {
        debugPrint(
          'Warning: NotificationService is null, cannot show notification',
        );
        return;
      }

      _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: message.notification?.title ?? 'Learning Reminder',
        body: message.notification?.body ?? 'Time to check your learning tasks',
        isImportant: message.data['priority'] == 'high',
      );
    } catch (e) {
      debugPrint('Error showing notification from FCM: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}
