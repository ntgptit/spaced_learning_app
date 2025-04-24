// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$booksStateHash() => r'0dbb71355fe4062bcda91c03d730e1bc506ea755';

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
String _$selectedBookHash() => r'75ee0f136ac9a7ad7f4a5c40a16e5e7bb0d92b06';

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
String _$categoriesHash() => r'cb673f3b51faebed569b6ef88998a4a50c980568';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AutoDisposeAsyncNotifierProvider<Categories, List<String>>.internal(
      Categories.new,
      name: r'categoriesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Categories = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
