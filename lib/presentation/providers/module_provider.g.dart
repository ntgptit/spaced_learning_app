// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookModulesHash() => r'9df449ea76c2f3edb11139a780996350eebfcd62';

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

/// See also [bookModules].
@ProviderFor(bookModules)
const bookModulesProvider = BookModulesFamily();

/// See also [bookModules].
class BookModulesFamily extends Family<AsyncValue<List<ModuleSummary>>> {
  /// See also [bookModules].
  const BookModulesFamily();

  /// See also [bookModules].
  BookModulesProvider call(String bookId, {int page = 0, int size = 20}) {
    return BookModulesProvider(bookId, page: page, size: size);
  }

  @override
  BookModulesProvider getProviderOverride(
    covariant BookModulesProvider provider,
  ) {
    return call(provider.bookId, page: provider.page, size: provider.size);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookModulesProvider';
}

/// See also [bookModules].
class BookModulesProvider
    extends AutoDisposeFutureProvider<List<ModuleSummary>> {
  /// See also [bookModules].
  BookModulesProvider(String bookId, {int page = 0, int size = 20})
    : this._internal(
        (ref) =>
            bookModules(ref as BookModulesRef, bookId, page: page, size: size),
        from: bookModulesProvider,
        name: r'bookModulesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$bookModulesHash,
        dependencies: BookModulesFamily._dependencies,
        allTransitiveDependencies: BookModulesFamily._allTransitiveDependencies,
        bookId: bookId,
        page: page,
        size: size,
      );

  BookModulesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
    required this.page,
    required this.size,
  }) : super.internal();

  final String bookId;
  final int page;
  final int size;

  @override
  Override overrideWith(
    FutureOr<List<ModuleSummary>> Function(BookModulesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookModulesProvider._internal(
        (ref) => create(ref as BookModulesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
        page: page,
        size: size,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ModuleSummary>> createElement() {
    return _BookModulesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookModulesProvider &&
        other.bookId == bookId &&
        other.page == page &&
        other.size == size;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, size.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookModulesRef on AutoDisposeFutureProviderRef<List<ModuleSummary>> {
  /// The parameter `bookId` of this provider.
  String get bookId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;
}

class _BookModulesProviderElement
    extends AutoDisposeFutureProviderElement<List<ModuleSummary>>
    with BookModulesRef {
  _BookModulesProviderElement(super.provider);

  @override
  String get bookId => (origin as BookModulesProvider).bookId;
  @override
  int get page => (origin as BookModulesProvider).page;
  @override
  int get size => (origin as BookModulesProvider).size;
}

String _$moduleDetailHash() => r'2932f50b95a70943ce0a962356f4887ee594e03d';

/// See also [moduleDetail].
@ProviderFor(moduleDetail)
const moduleDetailProvider = ModuleDetailFamily();

/// See also [moduleDetail].
class ModuleDetailFamily extends Family<AsyncValue<ModuleDetail>> {
  /// See also [moduleDetail].
  const ModuleDetailFamily();

  /// See also [moduleDetail].
  ModuleDetailProvider call(String id) {
    return ModuleDetailProvider(id);
  }

  @override
  ModuleDetailProvider getProviderOverride(
    covariant ModuleDetailProvider provider,
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
  String? get name => r'moduleDetailProvider';
}

/// See also [moduleDetail].
class ModuleDetailProvider extends AutoDisposeFutureProvider<ModuleDetail> {
  /// See also [moduleDetail].
  ModuleDetailProvider(String id)
    : this._internal(
        (ref) => moduleDetail(ref as ModuleDetailRef, id),
        from: moduleDetailProvider,
        name: r'moduleDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$moduleDetailHash,
        dependencies: ModuleDetailFamily._dependencies,
        allTransitiveDependencies:
            ModuleDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ModuleDetailProvider._internal(
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
    FutureOr<ModuleDetail> Function(ModuleDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ModuleDetailProvider._internal(
        (ref) => create(ref as ModuleDetailRef),
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
  AutoDisposeFutureProviderElement<ModuleDetail> createElement() {
    return _ModuleDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ModuleDetailProvider && other.id == id;
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
mixin ModuleDetailRef on AutoDisposeFutureProviderRef<ModuleDetail> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ModuleDetailProviderElement
    extends AutoDisposeFutureProviderElement<ModuleDetail>
    with ModuleDetailRef {
  _ModuleDetailProviderElement(super.provider);

  @override
  String get id => (origin as ModuleDetailProvider).id;
}

String _$modulesHash() => r'97c44beb0ee2ee7b1234326b39e82ce3b9ef3360';

abstract class _$Modules
    extends BuildlessAutoDisposeAsyncNotifier<List<ModuleSummary>> {
  late final int page;
  late final int size;

  FutureOr<List<ModuleSummary>> build({int page = 0, int size = 20});
}

/// See also [Modules].
@ProviderFor(Modules)
const modulesProvider = ModulesFamily();

/// See also [Modules].
class ModulesFamily extends Family<AsyncValue<List<ModuleSummary>>> {
  /// See also [Modules].
  const ModulesFamily();

  /// See also [Modules].
  ModulesProvider call({int page = 0, int size = 20}) {
    return ModulesProvider(page: page, size: size);
  }

  @override
  ModulesProvider getProviderOverride(covariant ModulesProvider provider) {
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
  String? get name => r'modulesProvider';
}

/// See also [Modules].
class ModulesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Modules, List<ModuleSummary>> {
  /// See also [Modules].
  ModulesProvider({int page = 0, int size = 20})
    : this._internal(
        () =>
            Modules()
              ..page = page
              ..size = size,
        from: modulesProvider,
        name: r'modulesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$modulesHash,
        dependencies: ModulesFamily._dependencies,
        allTransitiveDependencies: ModulesFamily._allTransitiveDependencies,
        page: page,
        size: size,
      );

  ModulesProvider._internal(
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
  FutureOr<List<ModuleSummary>> runNotifierBuild(covariant Modules notifier) {
    return notifier.build(page: page, size: size);
  }

  @override
  Override overrideWith(Modules Function() create) {
    return ProviderOverride(
      origin: this,
      override: ModulesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<Modules, List<ModuleSummary>>
  createElement() {
    return _ModulesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ModulesProvider && other.page == page && other.size == size;
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
mixin ModulesRef on AutoDisposeAsyncNotifierProviderRef<List<ModuleSummary>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;
}

class _ModulesProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<Modules, List<ModuleSummary>>
    with ModulesRef {
  _ModulesProviderElement(super.provider);

  @override
  int get page => (origin as ModulesProvider).page;
  @override
  int get size => (origin as ModulesProvider).size;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
