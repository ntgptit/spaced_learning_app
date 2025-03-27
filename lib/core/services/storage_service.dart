import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';

/// Service for handling local storage operations
class StorageService {
  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  StorageService({
    FlutterSecureStorage? secureStorage,
    Future<SharedPreferences>? prefs,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _prefs = prefs ?? SharedPreferences.getInstance();

  /// Clear all authentication tokens
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return _secureStorage.read(key: AppConstants.tokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  /// Get user data from storage
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _prefs;
    final userData = prefs.getString(AppConstants.userKey);

    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  /// Check if dark mode is enabled
  Future<bool> isDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.darkModeKey) ?? false;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: refreshToken,
    );
  }

  /// Save user data to storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }

  /// Save dark mode preference
  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.darkModeKey, isDarkMode);
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.userKey);
  }

  /// Get value by key
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  /// Save value by key
  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  /// Get boolean value by key
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  /// Save boolean value by key
  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }
}
