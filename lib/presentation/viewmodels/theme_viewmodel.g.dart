// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDarkModeHash() => r'ff7fb95afdf8dfc9cead877b9c0e8a6d1b66d7c6';

/// See also [isDarkMode].
@ProviderFor(isDarkMode)
final isDarkModeProvider = AutoDisposeProvider<bool>.internal(
  isDarkMode,
  name: r'isDarkModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDarkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDarkModeRef = AutoDisposeProviderRef<bool>;
String _$themeStateHash() => r'3174b2dae46d3f0d42c9d7f365f106790a6137bd';

/// See also [ThemeState].
@ProviderFor(ThemeState)
final themeStateProvider =
    AutoDisposeNotifierProvider<ThemeState, ThemeMode>.internal(
      ThemeState.new,
      name: r'themeStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeState = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
