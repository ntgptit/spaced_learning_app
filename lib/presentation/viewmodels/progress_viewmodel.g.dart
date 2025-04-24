// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isUpdatingProgressHash() =>
    r'7a40b52e4c99fb3823efd48d99cef5f3b9d941b2';

/// See also [isUpdatingProgress].
@ProviderFor(isUpdatingProgress)
final isUpdatingProgressProvider = AutoDisposeProvider<bool>.internal(
  isUpdatingProgress,
  name: r'isUpdatingProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$isUpdatingProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsUpdatingProgressRef = AutoDisposeProviderRef<bool>;
String _$progressStateHash() => r'95f3fb0e603d3ca755e418383661a6a8c1922cba';

/// See also [ProgressState].
@ProviderFor(ProgressState)
final progressStateProvider = AutoDisposeAsyncNotifierProvider<
  ProgressState,
  List<ProgressSummary>
>.internal(
  ProgressState.new,
  name: r'progressStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$progressStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgressState = AutoDisposeAsyncNotifier<List<ProgressSummary>>;
String _$selectedProgressHash() => r'4d5a8963d1b1857cde25050731b2a9b0204b301a';

/// See also [SelectedProgress].
@ProviderFor(SelectedProgress)
final selectedProgressProvider = AutoDisposeAsyncNotifierProvider<
  SelectedProgress,
  ProgressDetail?
>.internal(
  SelectedProgress.new,
  name: r'selectedProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedProgress = AutoDisposeAsyncNotifier<ProgressDetail?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
