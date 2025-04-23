// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDarkModeHash() => r'ebf29296cefbdba79bd3281f8300daad4ddabf8a';

/// See also [isDarkMode].
@ProviderFor(isDarkMode)
final isDarkModeProvider = AutoDisposeFutureProvider<bool>.internal(
  isDarkMode,
  name: r'isDarkModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDarkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDarkModeRef = AutoDisposeFutureProviderRef<bool>;
String _$themeStateHash() => r'dcc4a22f9f4c80f4370262ff054e3b6544382155';

/// See also [ThemeState].
@ProviderFor(ThemeState)
final themeStateProvider =
    AutoDisposeNotifierProvider<ThemeState, bool>.internal(
      ThemeState.new,
      name: r'themeStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
