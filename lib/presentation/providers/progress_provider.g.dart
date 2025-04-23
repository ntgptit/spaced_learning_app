// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserModuleProgressHash() =>
    r'418fdaeb6e01ad6c904c148b6c6654269599d6a2';

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

/// See also [currentUserModuleProgress].
@ProviderFor(currentUserModuleProgress)
const currentUserModuleProgressProvider = CurrentUserModuleProgressFamily();

/// See also [currentUserModuleProgress].
class CurrentUserModuleProgressFamily
    extends Family<AsyncValue<ProgressDetail?>> {
  /// See also [currentUserModuleProgress].
  const CurrentUserModuleProgressFamily();

  /// See also [currentUserModuleProgress].
  CurrentUserModuleProgressProvider call(String moduleId) {
    return CurrentUserModuleProgressProvider(moduleId);
  }

  @override
  CurrentUserModuleProgressProvider getProviderOverride(
    covariant CurrentUserModuleProgressProvider provider,
  ) {
    return call(provider.moduleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentUserModuleProgressProvider';
}

/// See also [currentUserModuleProgress].
class CurrentUserModuleProgressProvider
    extends AutoDisposeFutureProvider<ProgressDetail?> {
  /// See also [currentUserModuleProgress].
  CurrentUserModuleProgressProvider(String moduleId)
    : this._internal(
        (ref) => currentUserModuleProgress(
          ref as CurrentUserModuleProgressRef,
          moduleId,
        ),
        from: currentUserModuleProgressProvider,
        name: r'currentUserModuleProgressProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$currentUserModuleProgressHash,
        dependencies: CurrentUserModuleProgressFamily._dependencies,
        allTransitiveDependencies:
            CurrentUserModuleProgressFamily._allTransitiveDependencies,
        moduleId: moduleId,
      );

  CurrentUserModuleProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.moduleId,
  }) : super.internal();

  final String moduleId;

  @override
  Override overrideWith(
    FutureOr<ProgressDetail?> Function(CurrentUserModuleProgressRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentUserModuleProgressProvider._internal(
        (ref) => create(ref as CurrentUserModuleProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        moduleId: moduleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProgressDetail?> createElement() {
    return _CurrentUserModuleProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentUserModuleProgressProvider &&
        other.moduleId == moduleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, moduleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentUserModuleProgressRef
    on AutoDisposeFutureProviderRef<ProgressDetail?> {
  /// The parameter `moduleId` of this provider.
  String get moduleId;
}

class _CurrentUserModuleProgressProviderElement
    extends AutoDisposeFutureProviderElement<ProgressDetail?>
    with CurrentUserModuleProgressRef {
  _CurrentUserModuleProgressProviderElement(super.provider);

  @override
  String get moduleId => (origin as CurrentUserModuleProgressProvider).moduleId;
}

String _$progressDetailHash() => r'90e22c3d7ced71a34f9e6bbbde318e75263589b6';

/// See also [progressDetail].
@ProviderFor(progressDetail)
const progressDetailProvider = ProgressDetailFamily();

/// See also [progressDetail].
class ProgressDetailFamily extends Family<AsyncValue<ProgressDetail>> {
  /// See also [progressDetail].
  const ProgressDetailFamily();

  /// See also [progressDetail].
  ProgressDetailProvider call(String id) {
    return ProgressDetailProvider(id);
  }

  @override
  ProgressDetailProvider getProviderOverride(
    covariant ProgressDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'progressDetailProvider';
}

/// See also [progressDetail].
class ProgressDetailProvider extends AutoDisposeFutureProvider<ProgressDetail> {
  /// See also [progressDetail].
  ProgressDetailProvider(String id)
    : this._internal(
        (ref) => progressDetail(ref as ProgressDetailRef, id),
        from: progressDetailProvider,
        name: r'progressDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$progressDetailHash,
        dependencies: ProgressDetailFamily._dependencies,
        allTransitiveDependencies:
            ProgressDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ProgressDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ProgressDetail> Function(ProgressDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgressDetailProvider._internal(
        (ref) => create(ref as ProgressDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProgressDetail> createElement() {
    return _ProgressDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgressDetailRef on AutoDisposeFutureProviderRef<ProgressDetail> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProgressDetailProviderElement
    extends AutoDisposeFutureProviderElement<ProgressDetail>
    with ProgressDetailRef {
  _ProgressDetailProviderElement(super.provider);

  @override
  String get id => (origin as ProgressDetailProvider).id;
}

String _$dueProgressHash() => r'aae654e700b845eadf0764a7357d12aa75b3dd42';

/// See also [dueProgress].
@ProviderFor(dueProgress)
const dueProgressProvider = DueProgressFamily();

/// See also [dueProgress].
class DueProgressFamily extends Family<AsyncValue<List<ProgressSummary>>> {
  /// See also [dueProgress].
  const DueProgressFamily();

  /// See also [dueProgress].
  DueProgressProvider call(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) {
    return DueProgressProvider(
      userId,
      studyDate: studyDate,
      page: page,
      size: size,
    );
  }

  @override
  DueProgressProvider getProviderOverride(
    covariant DueProgressProvider provider,
  ) {
    return call(
      provider.userId,
      studyDate: provider.studyDate,
      page: provider.page,
      size: provider.size,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dueProgressProvider';
}

/// See also [dueProgress].
class DueProgressProvider
    extends AutoDisposeFutureProvider<List<ProgressSummary>> {
  /// See also [dueProgress].
  DueProgressProvider(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) : this._internal(
         (ref) => dueProgress(
           ref as DueProgressRef,
           userId,
           studyDate: studyDate,
           page: page,
           size: size,
         ),
         from: dueProgressProvider,
         name: r'dueProgressProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$dueProgressHash,
         dependencies: DueProgressFamily._dependencies,
         allTransitiveDependencies:
             DueProgressFamily._allTransitiveDependencies,
         userId: userId,
         studyDate: studyDate,
         page: page,
         size: size,
       );

  DueProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.studyDate,
    required this.page,
    required this.size,
  }) : super.internal();

  final String userId;
  final DateTime? studyDate;
  final int page;
  final int size;

  @override
  Override overrideWith(
    FutureOr<List<ProgressSummary>> Function(DueProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DueProgressProvider._internal(
        (ref) => create(ref as DueProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        studyDate: studyDate,
        page: page,
        size: size,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProgressSummary>> createElement() {
    return _DueProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DueProgressProvider &&
        other.userId == userId &&
        other.studyDate == studyDate &&
        other.page == page &&
        other.size == size;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, studyDate.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, size.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DueProgressRef on AutoDisposeFutureProviderRef<List<ProgressSummary>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `studyDate` of this provider.
  DateTime? get studyDate;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;
}

class _DueProgressProviderElement
    extends AutoDisposeFutureProviderElement<List<ProgressSummary>>
    with DueProgressRef {
  _DueProgressProviderElement(super.provider);

  @override
  String get userId => (origin as DueProgressProvider).userId;
  @override
  DateTime? get studyDate => (origin as DueProgressProvider).studyDate;
  @override
  int get page => (origin as DueProgressProvider).page;
  @override
  int get size => (origin as DueProgressProvider).size;
}

String _$progressHash() => r'133695929e8d8b5bb9440af8863bc49bf1338556';

abstract class _$Progress
    extends BuildlessAutoDisposeAsyncNotifier<List<ProgressSummary>> {
  late final int page;
  late final int size;

  FutureOr<List<ProgressSummary>> build({int page = 0, int size = 20});
}

/// See also [Progress].
@ProviderFor(Progress)
const progressProvider = ProgressFamily();

/// See also [Progress].
class ProgressFamily extends Family<AsyncValue<List<ProgressSummary>>> {
  /// See also [Progress].
  const ProgressFamily();

  /// See also [Progress].
  ProgressProvider call({int page = 0, int size = 20}) {
    return ProgressProvider(page: page, size: size);
  }

  @override
  ProgressProvider getProviderOverride(covariant ProgressProvider provider) {
    return call(page: provider.page, size: provider.size);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'progressProvider';
}

/// See also [Progress].
class ProgressProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<Progress, List<ProgressSummary>> {
  /// See also [Progress].
  ProgressProvider({int page = 0, int size = 20})
    : this._internal(
        () =>
            Progress()
              ..page = page
              ..size = size,
        from: progressProvider,
        name: r'progressProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$progressHash,
        dependencies: ProgressFamily._dependencies,
        allTransitiveDependencies: ProgressFamily._allTransitiveDependencies,
        page: page,
        size: size,
      );

  ProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.size,
  }) : super.internal();

  final int page;
  final int size;

  @override
  FutureOr<List<ProgressSummary>> runNotifierBuild(
    covariant Progress notifier,
  ) {
    return notifier.build(page: page, size: size);
  }

  @override
  Override overrideWith(Progress Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProgressProvider._internal(
        () =>
            create()
              ..page = page
              ..size = size,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        size: size,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Progress, List<ProgressSummary>>
  createElement() {
    return _ProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressProvider &&
        other.page == page &&
        other.size == size;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, size.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgressRef
    on AutoDisposeAsyncNotifierProviderRef<List<ProgressSummary>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;
}

class _ProgressProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<Progress, List<ProgressSummary>>
    with ProgressRef {
  _ProgressProviderElement(super.provider);

  @override
  int get page => (origin as ProgressProvider).page;
  @override
  int get size => (origin as ProgressProvider).size;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
