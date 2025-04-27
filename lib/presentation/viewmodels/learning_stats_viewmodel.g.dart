// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_stats_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadAllStatsHash() => r'61604458b6703c119a3a1fd5f606bed135b16102';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [loadAllStats].
@ProviderFor(loadAllStats)
const loadAllStatsProvider = LoadAllStatsFamily();

/// See also [loadAllStats].
class LoadAllStatsFamily extends Family<AsyncValue<void>> {
  /// See also [loadAllStats].
  const LoadAllStatsFamily();

  /// See also [loadAllStats].
  LoadAllStatsProvider call({required bool refreshCache}) {
    return LoadAllStatsProvider(refreshCache: refreshCache);
  }

  @override
  LoadAllStatsProvider getProviderOverride(
    covariant LoadAllStatsProvider provider,
  ) {
    return call(refreshCache: provider.refreshCache);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loadAllStatsProvider';
}

/// See also [loadAllStats].
class LoadAllStatsProvider extends AutoDisposeFutureProvider<void> {
  /// See also [loadAllStats].
  LoadAllStatsProvider({required bool refreshCache})
    : this._internal(
        (ref) =>
            loadAllStats(ref as LoadAllStatsRef, refreshCache: refreshCache),
        from: loadAllStatsProvider,
        name: r'loadAllStatsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$loadAllStatsHash,
        dependencies: LoadAllStatsFamily._dependencies,
        allTransitiveDependencies:
            LoadAllStatsFamily._allTransitiveDependencies,
        refreshCache: refreshCache,
      );

  LoadAllStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.refreshCache,
  }) : super.internal();

  final bool refreshCache;

  @override
  Override overrideWith(
    FutureOr<void> Function(LoadAllStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadAllStatsProvider._internal(
        (ref) => create(ref as LoadAllStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        refreshCache: refreshCache,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _LoadAllStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadAllStatsProvider && other.refreshCache == refreshCache;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, refreshCache.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoadAllStatsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `refreshCache` of this provider.
  bool get refreshCache;
}

class _LoadAllStatsProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with LoadAllStatsRef {
  _LoadAllStatsProviderElement(super.provider);

  @override
  bool get refreshCache => (origin as LoadAllStatsProvider).refreshCache;
}

String _$learningStatsStateHash() =>
    r'de561a7fd5152aa18225dc9bd91d804991b3723b';

/// See also [LearningStatsState].
@ProviderFor(LearningStatsState)
final learningStatsStateProvider = AutoDisposeAsyncNotifierProvider<
  LearningStatsState,
  LearningStatsDTO?
>.internal(
  LearningStatsState.new,
  name: r'learningStatsStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningStatsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LearningStatsState = AutoDisposeAsyncNotifier<LearningStatsDTO?>;
String _$learningInsightsHash() => r'1db8e90c2ec6800cfa8c44480ada6546b357b561';

/// See also [LearningInsights].
@ProviderFor(LearningInsights)
final learningInsightsProvider = AutoDisposeAsyncNotifierProvider<
  LearningInsights,
  List<LearningInsightRespone>
>.internal(
  LearningInsights.new,
  name: r'learningInsightsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningInsightsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LearningInsights =
    AutoDisposeAsyncNotifier<List<LearningInsightRespone>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
