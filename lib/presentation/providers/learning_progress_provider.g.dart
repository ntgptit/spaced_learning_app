// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uniqueBooksHash() => r'd7fd8e651da7c9504e020e27742c209a88233a42';

/// See also [uniqueBooks].
@ProviderFor(uniqueBooks)
final uniqueBooksProvider = AutoDisposeFutureProvider<List<String>>.internal(
  uniqueBooks,
  name: r'uniqueBooksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$uniqueBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UniqueBooksRef = AutoDisposeFutureProviderRef<List<String>>;
String _$dueModulesHash() => r'57255d196bc73546808c23722329724fbfbd9008';

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

/// See also [dueModules].
@ProviderFor(dueModules)
const dueModulesProvider = DueModulesFamily();

/// See also [dueModules].
class DueModulesFamily extends Family<AsyncValue<List<LearningModule>>> {
  /// See also [dueModules].
  const DueModulesFamily();

  /// See also [dueModules].
  DueModulesProvider call(int daysThreshold) {
    return DueModulesProvider(daysThreshold);
  }

  @override
  DueModulesProvider getProviderOverride(
    covariant DueModulesProvider provider,
  ) {
    return call(provider.daysThreshold);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dueModulesProvider';
}

/// See also [dueModules].
class DueModulesProvider
    extends AutoDisposeFutureProvider<List<LearningModule>> {
  /// See also [dueModules].
  DueModulesProvider(int daysThreshold)
    : this._internal(
        (ref) => dueModules(ref as DueModulesRef, daysThreshold),
        from: dueModulesProvider,
        name: r'dueModulesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$dueModulesHash,
        dependencies: DueModulesFamily._dependencies,
        allTransitiveDependencies: DueModulesFamily._allTransitiveDependencies,
        daysThreshold: daysThreshold,
      );

  DueModulesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.daysThreshold,
  }) : super.internal();

  final int daysThreshold;

  @override
  Override overrideWith(
    FutureOr<List<LearningModule>> Function(DueModulesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DueModulesProvider._internal(
        (ref) => create(ref as DueModulesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        daysThreshold: daysThreshold,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LearningModule>> createElement() {
    return _DueModulesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DueModulesProvider && other.daysThreshold == daysThreshold;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, daysThreshold.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DueModulesRef on AutoDisposeFutureProviderRef<List<LearningModule>> {
  /// The parameter `daysThreshold` of this provider.
  int get daysThreshold;
}

class _DueModulesProviderElement
    extends AutoDisposeFutureProviderElement<List<LearningModule>>
    with DueModulesRef {
  _DueModulesProviderElement(super.provider);

  @override
  int get daysThreshold => (origin as DueModulesProvider).daysThreshold;
}

String _$learningProgressHash() => r'077e3f9343bde6175fb85ed4ab66e38b03609013';

/// See also [LearningProgress].
@ProviderFor(LearningProgress)
final learningProgressProvider = AutoDisposeAsyncNotifierProvider<
  LearningProgress,
  List<LearningModule>
>.internal(
  LearningProgress.new,
  name: r'learningProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LearningProgress = AutoDisposeAsyncNotifier<List<LearningModule>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
