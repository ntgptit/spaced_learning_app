import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ThemeViewModel extends BaseViewModel {
  final StorageService storageService;

  bool _isDarkMode = false;

  ThemeViewModel({required this.storageService}) {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

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

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      await storageService.saveDarkMode(_isDarkMode);
    } catch (e) {
      _isDarkMode = !_isDarkMode;
      handleError(e, prefix: 'Failed to save theme preference');
    }
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) return;

    _isDarkMode = isDarkMode;
    notifyListeners();

    try {
      await storageService.saveDarkMode(_isDarkMode);
    } catch (e) {
      _isDarkMode = !_isDarkMode;
      handleError(e, prefix: 'Failed to save theme preference');
    }
  }
}
