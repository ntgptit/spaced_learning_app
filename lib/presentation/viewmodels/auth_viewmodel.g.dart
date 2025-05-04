// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'a85fae33b75fd83c99c8454e08bcd3fb9de7fc66';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider = AsyncNotifierProvider<AuthState, bool>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AsyncNotifier<bool>;
String _$currentUserHash() => r'20f0fea4e181bbb6d7195f3eb1d667129a7495cc';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider = NotifierProvider<CurrentUser, User?>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = Notifier<User?>;
String _$authErrorHash() => r'2e305f21f75dffcd046dafa1db3126093237df76';

/// See also [AuthError].
@ProviderFor(AuthError)
final authErrorProvider =
    AutoDisposeNotifierProvider<AuthError, String?>.internal(
      AuthError.new,
      name: r'authErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthError = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
