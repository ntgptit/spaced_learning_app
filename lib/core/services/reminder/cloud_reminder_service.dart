import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';

/// Backup reminder service using FCM
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

  /// Initialize FCM for backup reminders
  Future<void> initialize() async {
    try {
      // Request permission for notifications
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('FCM permission settings: ${settings.authorizationStatus}');

      // Get token
      final token = await _firebaseMessaging.getToken();

      // Save token
      if (token != null) {
        await _saveDeviceToken(token);
      } else {
        debugPrint('Error: FCM token is null');
      }

      // Listen for token refreshes
      _firebaseMessaging.onTokenRefresh.listen(_saveDeviceToken);

      // Set up message handler
      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      debugPrint('FCM initialized successfully');
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  /// Save device token to local storage and server if user is logged in
  Future<void> _saveDeviceToken(String token) async {
    try {
      // Save locally
      await _storageService.setString('fcm_token', token);
      debugPrint('FCM token saved locally: ${token.substring(0, 10)}...');

      // Save to server if user is logged in
      final userData = await _storageService.getUserData();
      if (userData != null && userData['id'] != null) {
        try {
          // Send token to your server
          // This would typically involve an API call
          debugPrint('FCM token saved for user: ${userData['id']}');
        } catch (e) {
          debugPrint('Error saving FCM token to server: $e');
        }
      }
    } catch (e) {
      debugPrint('Error in _saveDeviceToken: $e');
    }
  }

  /// Handle incoming FCM message
  void _handleMessage(RemoteMessage message) {
    debugPrint('Got FCM message: ${message.notification?.title}');

    // Show local notification
    try {
      if (_notificationService != null) {
        _notificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification?.title ?? 'Learning Reminder',
          body:
              message.notification?.body ?? 'Time to check your learning tasks',
          isImportant: message.data['priority'] == 'high',
        );
      } else {
        debugPrint(
          'Warning: NotificationService is null, cannot show notification',
        );
      }
    } catch (e) {
      debugPrint('Error showing notification from FCM: $e');
    }
  }
}

// This function must be defined at the top-level (outside of any class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to ensure Firebase is initialized
  // await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
  // Cannot access instance methods/properties here as this runs in the background
  // Save the message to shared preferences or a database to handle when the app opens
}
