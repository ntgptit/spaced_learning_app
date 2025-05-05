// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_progress_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dueModulesCountHash() => r'2554924329ab074e73b5da3b32a42e9e64efbc53';

/// See also [dueModulesCount].
@ProviderFor(dueModulesCount)
final dueModulesCountProvider = AutoDisposeProvider<int>.internal(
  dueModulesCount,
  name: r'dueModulesCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dueModulesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DueModulesCountRef = AutoDisposeProviderRef<int>;
String _$completedModulesCountHash() =>
    r'4741af4ace8b5e810447dd3fb27c0ffd9f63a80e';

/// See also [completedModulesCount].
@ProviderFor(completedModulesCount)
final completedModulesCountProvider = AutoDisposeProvider<int>.internal(
  completedModulesCount,
  name: r'completedModulesCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedModulesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedModulesCountRef = AutoDisposeProviderRef<int>;
String _$learningProgressStateHash() =>
    r'2d557ff213d70c1ca76617bf4f8baab678f1bfe0';

/// See also [LearningProgressState].
@ProviderFor(LearningProgressState)
final learningProgressStateProvider = AutoDisposeAsyncNotifierProvider<
  LearningProgressState,
  List<LearningModule>
>.internal(
  LearningProgressState.new,
  name: r'learningProgressStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningProgressStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LearningProgressState =
    AutoDisposeAsyncNotifier<List<LearningModule>>;
String _$filteredModulesHash() => r'9a6706fb9cb1c6ce08403e37365a2bede5f6dd97';

/// See also [FilteredModules].
@ProviderFor(FilteredModules)
final filteredModulesProvider =
    AutoDisposeNotifierProvider<FilteredModules, List<LearningModule>>.internal(
      FilteredModules.new,
      name: r'filteredModulesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredModulesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FilteredModules = AutoDisposeNotifier<List<LearningModule>>;
String _$selectedBookFilterHash() =>
    r'aae94d5ed54795c43704c56d4ecf0a622e99443b';

/// See also [SelectedBookFilter].
@ProviderFor(SelectedBookFilter)
final selectedBookFilterProvider =
    AutoDisposeNotifierProvider<SelectedBookFilter, String>.internal(
      SelectedBookFilter.new,
      name: r'selectedBookFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedBookFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedBookFilter = AutoDisposeNotifier<String>;
String _$selectedDateFilterHash() =>
    r'cc96394ec4268553e5d7593f82ec35f3cee1ed6a';

/// See also [SelectedDateFilter].
@ProviderFor(SelectedDateFilter)
final selectedDateFilterProvider =
    AutoDisposeNotifierProvider<SelectedDateFilter, DateTime?>.internal(
      SelectedDateFilter.new,
      name: r'selectedDateFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedDateFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedDateFilter = AutoDisposeNotifier<DateTime?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
