// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lightThemeHash() => r'e831759e5bda627e74c30d27c7ff299a38f7294e';

/// See also [lightTheme].
@ProviderFor(lightTheme)
final lightThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  lightTheme,
  name: r'lightThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lightThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LightThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$darkThemeHash() => r'de495df328aa639f862ca7bc7c1d8512e8475059';

/// See also [darkTheme].
@ProviderFor(darkTheme)
final darkThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  darkTheme,
  name: r'darkThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$darkThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DarkThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$themeModeStateHash() => r'9fbadc6ea4d11bcf24188fdbcad18c64ed98e648';

/// See also [ThemeModeState].
@ProviderFor(ThemeModeState)
final themeModeStateProvider =
    AutoDisposeNotifierProvider<ThemeModeState, ThemeMode>.internal(
      ThemeModeState.new,
      name: r'themeModeStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeModeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeModeState = AutoDisposeNotifier<ThemeMode>;
String _$isDarkModeHash() => r'f5f49952d8bbbc59f171ee5c25740323554d92a8';

/// See also [IsDarkMode].
@ProviderFor(IsDarkMode)
final isDarkModeProvider =
    AutoDisposeAsyncNotifierProvider<IsDarkMode, bool>.internal(
      IsDarkMode.new,
      name: r'isDarkModeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$isDarkModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IsDarkMode = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
