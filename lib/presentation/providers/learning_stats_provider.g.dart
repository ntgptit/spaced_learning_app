// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$learningInsightsHash() => r'6ce9152e1b59ed40a238b14b8c46ea5116f7398c';

/// See also [learningInsights].
@ProviderFor(learningInsights)
final learningInsightsProvider =
    AutoDisposeFutureProvider<List<LearningInsightDTO>>.internal(
      learningInsights,
      name: r'learningInsightsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$learningInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearningInsightsRef =
    AutoDisposeFutureProviderRef<List<LearningInsightDTO>>;
String _$learningStatsHash() => r'050b74eac00feda112eea074208f8d86e0ddb132';

/// See also [LearningStats].
@ProviderFor(LearningStats)
final learningStatsProvider =
    AutoDisposeAsyncNotifierProvider<LearningStats, LearningStatsDTO>.internal(
      LearningStats.new,
      name: r'learningStatsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$learningStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LearningStats = AutoDisposeAsyncNotifier<LearningStatsDTO>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
