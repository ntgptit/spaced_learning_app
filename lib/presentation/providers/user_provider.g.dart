// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'b442d8a6195b6d62a842968ce2b160a3ac612dbf';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeFutureProvider<User>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeFutureProviderRef<User>;
String _$userStateHash() => r'3b922021342622ec161b0f8c99ea19fb1a541a45';

/// See also [UserState].
@ProviderFor(UserState)
final userStateProvider =
    AutoDisposeAsyncNotifierProvider<UserState, User>.internal(
      UserState.new,
      name: r'userStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserState = AutoDisposeAsyncNotifier<User>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
