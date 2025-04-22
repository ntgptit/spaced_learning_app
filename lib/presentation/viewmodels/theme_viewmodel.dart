import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ThemeViewModel extends BaseViewModel {
  final StorageService storageService;

  bool _isDarkMode = false;

  ThemeViewModel({required this.storageService}) {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  /// Load theme preference from storage
  Future<void> _loadThemePreference() async {
    beginLoading();

    try {
      _isDarkMode = await storageService.isDarkMode();
      setInitialized(true);
    } catch (e) {
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
      _isDarkMode = !_isDarkMode; // Revert if saving fails
      handleError(e, prefix: 'Failed to save theme preference');
    }
  }

  /// Set specific dark mode value
  Future<void> setDarkMode(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) return;

    _isDarkMode = isDarkMode;
    notifyListeners();

    try {
      await storageService.saveDarkMode(_isDarkMode);
    } catch (e) {
      _isDarkMode = !_isDarkMode; // Revert if saving fails
      handleError(e, prefix: 'Failed to save theme preference');
    }
  }
}
