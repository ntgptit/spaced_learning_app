// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repetition_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$progressRepetitionsHash() =>
    r'6bf56af77c558060ce8170117e790aa32540b7ee';

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

/// See also [progressRepetitions].
@ProviderFor(progressRepetitions)
const progressRepetitionsProvider = ProgressRepetitionsFamily();

/// See also [progressRepetitions].
class ProgressRepetitionsFamily extends Family<AsyncValue<List<Repetition>>> {
  /// See also [progressRepetitions].
  const ProgressRepetitionsFamily();

  /// See also [progressRepetitions].
  ProgressRepetitionsProvider call(String progressId) {
    return ProgressRepetitionsProvider(progressId);
  }

  @override
  ProgressRepetitionsProvider getProviderOverride(
    covariant ProgressRepetitionsProvider provider,
  ) {
    return call(provider.progressId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'progressRepetitionsProvider';
}

/// See also [progressRepetitions].
class ProgressRepetitionsProvider
    extends AutoDisposeFutureProvider<List<Repetition>> {
  /// See also [progressRepetitions].
  ProgressRepetitionsProvider(String progressId)
    : this._internal(
        (ref) => progressRepetitions(ref as ProgressRepetitionsRef, progressId),
        from: progressRepetitionsProvider,
        name: r'progressRepetitionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$progressRepetitionsHash,
        dependencies: ProgressRepetitionsFamily._dependencies,
        allTransitiveDependencies:
            ProgressRepetitionsFamily._allTransitiveDependencies,
        progressId: progressId,
      );

  ProgressRepetitionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.progressId,
  }) : super.internal();

  final String progressId;

  @override
  Override overrideWith(
    FutureOr<List<Repetition>> Function(ProgressRepetitionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgressRepetitionsProvider._internal(
        (ref) => create(ref as ProgressRepetitionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        progressId: progressId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Repetition>> createElement() {
    return _ProgressRepetitionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressRepetitionsProvider &&
        other.progressId == progressId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, progressId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgressRepetitionsRef on AutoDisposeFutureProviderRef<List<Repetition>> {
  /// The parameter `progressId` of this provider.
  String get progressId;
}

class _ProgressRepetitionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Repetition>>
    with ProgressRepetitionsRef {
  _ProgressRepetitionsProviderElement(super.provider);

  @override
  String get progressId => (origin as ProgressRepetitionsProvider).progressId;
}

String _$repetitionsHash() => r'd05a76062b2a8777b987b2240875b60433ed0ebe';

abstract class _$Repetitions
    extends BuildlessAutoDisposeAsyncNotifier<List<Repetition>> {
  late final String? progressId;

  FutureOr<List<Repetition>> build({String? progressId});
}

/// See also [Repetitions].
@ProviderFor(Repetitions)
const repetitionsProvider = RepetitionsFamily();

/// See also [Repetitions].
class RepetitionsFamily extends Family<AsyncValue<List<Repetition>>> {
  /// See also [Repetitions].
  const RepetitionsFamily();

  /// See also [Repetitions].
  RepetitionsProvider call({String? progressId}) {
    return RepetitionsProvider(progressId: progressId);
  }

  @override
  RepetitionsProvider getProviderOverride(
    covariant RepetitionsProvider provider,
  ) {
    return call(progressId: provider.progressId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'repetitionsProvider';
}

/// See also [Repetitions].
class RepetitionsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<Repetitions, List<Repetition>> {
  /// See also [Repetitions].
  RepetitionsProvider({String? progressId})
    : this._internal(
        () => Repetitions()..progressId = progressId,
        from: repetitionsProvider,
        name: r'repetitionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$repetitionsHash,
        dependencies: RepetitionsFamily._dependencies,
        allTransitiveDependencies: RepetitionsFamily._allTransitiveDependencies,
        progressId: progressId,
      );

  RepetitionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.progressId,
  }) : super.internal();

  final String? progressId;

  @override
  FutureOr<List<Repetition>> runNotifierBuild(covariant Repetitions notifier) {
    return notifier.build(progressId: progressId);
  }

  @override
  Override overrideWith(Repetitions Function() create) {
    return ProviderOverride(
      origin: this,
      override: RepetitionsProvider._internal(
        () => create()..progressId = progressId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        progressId: progressId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Repetitions, List<Repetition>>
  createElement() {
    return _RepetitionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RepetitionsProvider && other.progressId == progressId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, progressId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RepetitionsRef on AutoDisposeAsyncNotifierProviderRef<List<Repetition>> {
  /// The parameter `progressId` of this provider.
  String? get progressId;
}

class _RepetitionsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<Repetitions, List<Repetition>>
    with RepetitionsRef {
  _RepetitionsProviderElement(super.provider);

  @override
  String? get progressId => (origin as RepetitionsProvider).progressId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
