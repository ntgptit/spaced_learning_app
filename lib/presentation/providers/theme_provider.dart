// lib/presentation/providers/theme_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/di/providers.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  @override
  bool build() {
    // Read the theme preference from storage
    final isDarkMode = ref.watch(isDarkModeProvider).valueOrNull ?? false;
    return isDarkMode;
  }

  void toggleTheme() async {
    final storageService = ref.read(storageServiceProvider);
    state = !state;
    await storageService.saveDarkMode(state);
  }
}

@riverpod
Future<bool> isDarkMode(IsDarkModeRef ref) async {
  final storageService = ref.watch(storageServiceProvider);
  return await storageService.isDarkMode();
}
