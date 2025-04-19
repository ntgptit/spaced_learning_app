import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  StorageService({
    FlutterSecureStorage? secureStorage,
    Future<SharedPreferences>? prefs,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _prefs = prefs ?? SharedPreferences.getInstance();

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: AppConstants.tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _prefs;
    final userData = prefs.getString(AppConstants.userKey);

    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> isDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.darkModeKey) ?? false;
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: refreshToken,
    );
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }

  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.darkModeKey, isDarkMode);
  }

  Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.userKey);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, value);
  }
}
