import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';

/// View model for theme settings
class ThemeViewModel extends ChangeNotifier {
  final StorageService storageService;

  bool _isDarkMode = false;
  bool _isLoading = false;

  ThemeViewModel({required this.storageService}) {
    _loadThemePreference();
  }

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  /// Load the theme preference from storage
  Future<void> _loadThemePreference() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isDarkMode = await storageService.isDarkMode();
    } catch (e) {
      // Default to light mode if there's an error
      _isDarkMode = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      await storageService.saveDarkMode(_isDarkMode);
    } catch (e) {
      // If there's an error saving, revert the change
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }

  /// Set specific theme mode
  Future<void> setDarkMode(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) return;

    _isDarkMode = isDarkMode;
    notifyListeners();

    try {
      await storageService.saveDarkMode(_isDarkMode);
    } catch (e) {
      // If there's an error saving, revert the change
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }
}
