// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_progress_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dueModulesCountHash() => r'6aaec3e0c6d140d561020fed34d225950dbbfdb8';

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
    r'5a8cc7a1ebf5e0f29b2a5df939204e3fc04b17e2';

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
    r'ac503f9f7c0ee211a744bed9d2195a72818d77d3';

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
    r'3e50f01a271fb9211619ecca0b1bcd3b36220904';

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
