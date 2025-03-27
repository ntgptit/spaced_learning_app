/// Application-wide constants
class AppConstants {
  // API related constants
  static const String baseUrl = 'http://10.0.2.2:8080'; // For Android emulator
  static const String apiPrefix = '/api/v1';
  static const int connectTimeout = 15000; // milliseconds
  static const int receiveTimeout = 15000; // milliseconds

  // Local storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String darkModeKey = 'dark_mode';

  // App settings
  static const String appName = 'Spaced Learning';

  // Animation durations
  static const Duration quickDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 350);
  static const Duration longDuration = Duration(milliseconds: 500);
}
