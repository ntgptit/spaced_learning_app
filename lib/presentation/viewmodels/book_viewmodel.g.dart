// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$booksStateHash() => r'80b4a6a7b1cbf3c9793f5b8a7df90f40c289152d';

/// See also [BooksState].
@ProviderFor(BooksState)
final booksStateProvider =
    AutoDisposeAsyncNotifierProvider<BooksState, List<BookSummary>>.internal(
      BooksState.new,
      name: r'booksStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$booksStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BooksState = AutoDisposeAsyncNotifier<List<BookSummary>>;
String _$selectedBookHash() => r'290aab623ba44522f212b92695791672a39fc9f3';

/// See also [SelectedBook].
@ProviderFor(SelectedBook)
final selectedBookProvider =
    AutoDisposeAsyncNotifierProvider<SelectedBook, BookDetail?>.internal(
      SelectedBook.new,
      name: r'selectedBookProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedBookHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedBook = AutoDisposeAsyncNotifier<BookDetail?>;
String _$categoriesHash() => r'097cc0d66f819605e2dd00bf20f2fba4c3e3d0fd';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AsyncNotifierProvider<Categories, List<String>>.internal(
      Categories.new,
      name: r'categoriesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Categories = AsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
