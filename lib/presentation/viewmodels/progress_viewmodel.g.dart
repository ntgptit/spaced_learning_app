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
String _$todayDueTasksHash() => r'55fceddcabfeec2b926189173c607431435563d1';

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
String _$trackedProgressStateHash() =>
    r'7cf75a9be08d0401dd6f052fe37a70188e6f8bb1';

/// See also [trackedProgressState].
@ProviderFor(trackedProgressState)
final trackedProgressStateProvider =
    AutoDisposeFutureProvider<List<ProgressDetail>>.internal(
      trackedProgressState,
      name: r'trackedProgressStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$trackedProgressStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrackedProgressStateRef =
    AutoDisposeFutureProviderRef<List<ProgressDetail>>;
String _$progressStateHash() => r'00e6be3ce98fadd89703c6c0a6c43f04ea12d383';

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
