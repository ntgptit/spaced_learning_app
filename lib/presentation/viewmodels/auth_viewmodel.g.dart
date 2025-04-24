// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'cf52090b1ae99fe451adf2dda192210600e66888';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider =
    AutoDisposeAsyncNotifierProvider<AuthState, bool>.internal(
      AuthState.new,
      name: r'authStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthState = AutoDisposeAsyncNotifier<bool>;
String _$currentUserHash() => r'1ec076673d8752c84cbe02110bd156a33e7d3986';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeNotifierProvider<CurrentUser, User?>.internal(
      CurrentUser.new,
      name: r'currentUserProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentUser = AutoDisposeNotifier<User?>;
String _$authErrorHash() => r'4e133a297fc5bc4b69af432013e029e41ceab2d9';

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
