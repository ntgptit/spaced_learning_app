// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isUpdatingProgressHash() =>
    r'05c10f5bb50043d10d1fa94ef06d598c5e5c20b2';

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
String _$todayDueTasksHash() => r'7fb56376b1c8db360d7ebcb640969e23c92ed0fd';

/// See also [todayDueTasks].
@ProviderFor(todayDueTasks)
final todayDueTasksProvider =
    AutoDisposeProvider<List<ProgressDetail>>.internal(
      todayDueTasks,
      name: r'todayDueTasksProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$todayDueTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayDueTasksRef = AutoDisposeProviderRef<List<ProgressDetail>>;
String _$todayDueTasksCountHash() =>
    r'03c0091906db433b7e6352024c542f18d411ce21';

/// See also [todayDueTasksCount].
@ProviderFor(todayDueTasksCount)
final todayDueTasksCountProvider = AutoDisposeProvider<int>.internal(
  todayDueTasksCount,
  name: r'todayDueTasksCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayDueTasksCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayDueTasksCountRef = AutoDisposeProviderRef<int>;
String _$progressStateHash() => r'5fd759dce667b60915b9c0f9ae23ebe82e54f5af';

/// See also [ProgressState].
@ProviderFor(ProgressState)
final progressStateProvider = AutoDisposeAsyncNotifierProvider<
  ProgressState,
  List<ProgressDetail>
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

typedef _$ProgressState = AutoDisposeAsyncNotifier<List<ProgressDetail>>;
String _$selectedProgressHash() => r'97b3285aa2bea9821e4639402e684704afc23782';

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
