// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookDetailHash() => r'e9a532e04687027e96e16e877d2c3b5f9e1a8a8d';

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

/// See also [bookDetail].
@ProviderFor(bookDetail)
const bookDetailProvider = BookDetailFamily();

/// See also [bookDetail].
class BookDetailFamily extends Family<AsyncValue<BookDetail>> {
  /// See also [bookDetail].
  const BookDetailFamily();

  /// See also [bookDetail].
  BookDetailProvider call(String id) {
    return BookDetailProvider(id);
  }

  @override
  BookDetailProvider getProviderOverride(
    covariant BookDetailProvider provider,
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
  String? get name => r'bookDetailProvider';
}

/// See also [bookDetail].
class BookDetailProvider extends AutoDisposeFutureProvider<BookDetail> {
  /// See also [bookDetail].
  BookDetailProvider(String id)
    : this._internal(
        (ref) => bookDetail(ref as BookDetailRef, id),
        from: bookDetailProvider,
        name: r'bookDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$bookDetailHash,
        dependencies: BookDetailFamily._dependencies,
        allTransitiveDependencies: BookDetailFamily._allTransitiveDependencies,
        id: id,
      );

  BookDetailProvider._internal(
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
    FutureOr<BookDetail> Function(BookDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookDetailProvider._internal(
        (ref) => create(ref as BookDetailRef),
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
  AutoDisposeFutureProviderElement<BookDetail> createElement() {
    return _BookDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookDetailProvider && other.id == id;
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
mixin BookDetailRef on AutoDisposeFutureProviderRef<BookDetail> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BookDetailProviderElement
    extends AutoDisposeFutureProviderElement<BookDetail>
    with BookDetailRef {
  _BookDetailProviderElement(super.provider);

  @override
  String get id => (origin as BookDetailProvider).id;
}

String _$bookCategoriesHash() => r'fba3a29a6d26d9ff5b51b148ea94a2c36e71f6d3';

/// See also [bookCategories].
@ProviderFor(bookCategories)
final bookCategoriesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  bookCategories,
  name: r'bookCategoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$booksHash() => r'bc15f7b1db99c4406fde726ad4becbc56ac79eb4';

abstract class _$Books
    extends BuildlessAutoDisposeAsyncNotifier<List<BookSummary>> {
  late final int page;
  late final int size;

  FutureOr<List<BookSummary>> build({int page = 0, int size = 20});
}

/// See also [Books].
@ProviderFor(Books)
const booksProvider = BooksFamily();

/// See also [Books].
class BooksFamily extends Family<AsyncValue<List<BookSummary>>> {
  /// See also [Books].
  const BooksFamily();

  /// See also [Books].
  BooksProvider call({int page = 0, int size = 20}) {
    return BooksProvider(page: page, size: size);
  }

  @override
  BooksProvider getProviderOverride(covariant BooksProvider provider) {
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
  String? get name => r'booksProvider';
}

/// See also [Books].
class BooksProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Books, List<BookSummary>> {
  /// See also [Books].
  BooksProvider({int page = 0, int size = 20})
    : this._internal(
        () =>
            Books()
              ..page = page
              ..size = size,
        from: booksProvider,
        name: r'booksProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$booksHash,
        dependencies: BooksFamily._dependencies,
        allTransitiveDependencies: BooksFamily._allTransitiveDependencies,
        page: page,
        size: size,
      );

  BooksProvider._internal(
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
  FutureOr<List<BookSummary>> runNotifierBuild(covariant Books notifier) {
    return notifier.build(page: page, size: size);
  }

  @override
  Override overrideWith(Books Function() create) {
    return ProviderOverride(
      origin: this,
      override: BooksProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<Books, List<BookSummary>>
  createElement() {
    return _BooksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BooksProvider && other.page == page && other.size == size;
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
mixin BooksRef on AutoDisposeAsyncNotifierProviderRef<List<BookSummary>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;
}

class _BooksProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Books, List<BookSummary>>
    with BooksRef {
  _BooksProviderElement(super.provider);

  @override
  int get page => (origin as BooksProvider).page;
  @override
  int get size => (origin as BooksProvider).size;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
