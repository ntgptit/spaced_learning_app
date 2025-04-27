// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userStateHash() => r'8dd2b6916ff6560373cb708ff7398fdc3b531584';

/// See also [UserState].
@ProviderFor(UserState)
final userStateProvider =
    AutoDisposeAsyncNotifierProvider<UserState, User?>.internal(
      UserState.new,
      name: r'userStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserState = AutoDisposeAsyncNotifier<User?>;
String _$userErrorHash() => r'f2a49aa5c7291f97ce057797704cdef0fca56d19';

/// See also [UserError].
@ProviderFor(UserError)
final userErrorProvider =
    AutoDisposeNotifierProvider<UserError, String?>.internal(
      UserError.new,
      name: r'userErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserError = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
