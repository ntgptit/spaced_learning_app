import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';

/// Backup reminder service using FCM
class CloudReminderService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StorageService _storageService;

  CloudReminderService({StorageService? storageService})
    : _storageService = storageService ?? serviceLocator<StorageService>();

  /// Initialize FCM for backup reminders
  Future<void> initialize() async {
    try {
      // Request permission for notifications
      await _firebaseMessaging.requestPermission();

      // Get token
      final token = await _firebaseMessaging.getToken();

      // Save token
      if (token != null) {
        await _saveDeviceToken(token);
      }

      // Listen for token refreshes
      _firebaseMessaging.onTokenRefresh.listen(_saveDeviceToken);

      // Set up message handler
      FirebaseMessaging.onMessage.listen(_handleMessage);

      debugPrint('FCM initialized successfully');
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  /// Save device token to local storage and server if user is logged in
  Future<void> _saveDeviceToken(String token) async {
    // Save locally
    await _storageService.setString('fcm_token', token);

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
  }

  /// Handle incoming FCM message
  void _handleMessage(RemoteMessage message) {
    debugPrint('Got FCM message: ${message.notification?.title}');

    // Show local notification
    try {
      final notificationService = serviceLocator<NotificationService>();

      notificationService.showNotification(
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
