// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repetition_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCycleInfoHash() => r'a17837d8d9a28325c3d686de75b21c380e6c518c';

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

/// See also [getCycleInfo].
@ProviderFor(getCycleInfo)
const getCycleInfoProvider = GetCycleInfoFamily();

/// See also [getCycleInfo].
class GetCycleInfoFamily extends Family<String> {
  /// See also [getCycleInfo].
  const GetCycleInfoFamily();

  /// See also [getCycleInfo].
  GetCycleInfoProvider call(CycleStudied cycle) {
    return GetCycleInfoProvider(cycle);
  }

  @override
  GetCycleInfoProvider getProviderOverride(
    covariant GetCycleInfoProvider provider,
  ) {
    return call(provider.cycle);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getCycleInfoProvider';
}

/// See also [getCycleInfo].
class GetCycleInfoProvider extends AutoDisposeProvider<String> {
  /// See also [getCycleInfo].
  GetCycleInfoProvider(CycleStudied cycle)
    : this._internal(
        (ref) => getCycleInfo(ref as GetCycleInfoRef, cycle),
        from: getCycleInfoProvider,
        name: r'getCycleInfoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getCycleInfoHash,
        dependencies: GetCycleInfoFamily._dependencies,
        allTransitiveDependencies:
            GetCycleInfoFamily._allTransitiveDependencies,
        cycle: cycle,
      );

  GetCycleInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cycle,
  }) : super.internal();

  final CycleStudied cycle;

  @override
  Override overrideWith(String Function(GetCycleInfoRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: GetCycleInfoProvider._internal(
        (ref) => create(ref as GetCycleInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cycle: cycle,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _GetCycleInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCycleInfoProvider && other.cycle == cycle;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cycle.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCycleInfoRef on AutoDisposeProviderRef<String> {
  /// The parameter `cycle` of this provider.
  CycleStudied get cycle;
}

class _GetCycleInfoProviderElement extends AutoDisposeProviderElement<String>
    with GetCycleInfoRef {
  _GetCycleInfoProviderElement(super.provider);

  @override
  CycleStudied get cycle => (origin as GetCycleInfoProvider).cycle;
}

String _$repetitionStateHash() => r'01ca993b9995ea78f6f7e234305c54e8a1f862ea';

/// See also [RepetitionState].
@ProviderFor(RepetitionState)
final repetitionStateProvider = AutoDisposeAsyncNotifierProvider<
  RepetitionState,
  List<Repetition>
>.internal(
  RepetitionState.new,
  name: r'repetitionStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$repetitionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RepetitionState = AutoDisposeAsyncNotifier<List<Repetition>>;
String _$selectedRepetitionHash() =>
    r'ee2e1a7cb6c815d08602634b3f375c89d22afe92';

/// See also [SelectedRepetition].
@ProviderFor(SelectedRepetition)
final selectedRepetitionProvider =
    AutoDisposeNotifierProvider<SelectedRepetition, Repetition?>.internal(
      SelectedRepetition.new,
      name: r'selectedRepetitionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedRepetitionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedRepetition = AutoDisposeNotifier<Repetition?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
