// lib/presentation/viewmodels/theme_viewmodel.dart
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// View model for theme settings
class ThemeViewModel extends BaseViewModel {
  final StorageService storageService;

  bool _isDarkMode = false;

  ThemeViewModel({required this.storageService}) {
    _loadThemePreference();
  }

  // Getters
  bool get isDarkMode => _isDarkMode;

  /// Load the theme preference from storage
  Future<void> _loadThemePreference() async {
    beginLoading();

    try {
      _isDarkMode = await storageService.isDarkMode();
      setInitialized(true);
    } catch (e) {
      // Default to light mode if there's an error
      _isDarkMode = false;
      handleError(e, prefix: 'Failed to load theme preference');
    } finally {
      endLoading();
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
      handleError(e, prefix: 'Failed to save theme preference');
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
      handleError(e, prefix: 'Failed to save theme preference');
    }
  }
}
