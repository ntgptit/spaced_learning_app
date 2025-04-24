// lib/presentation/viewmodels/book_viewmodel.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

import '../../core/di/providers.dart';

part 'book_viewmodel.g.dart';

@riverpod
class BooksState extends _$BooksState {
  @override
  Future<List<BookSummary>> build() async {
    return loadBooks();
  }

  Future<List<BookSummary>> loadBooks({int page = 0, int size = 20}) async {
    state = const AsyncValue.loading();
    try {
      final books = await ref
          .read(bookRepositoryProvider)
          .getAllBooks(page: page, size: size);
      state = AsyncValue.data(books);
      return books;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<List<BookSummary>> searchBooks(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    if (query.isEmpty) {
      return loadBooks(page: page, size: size);
    }

    try {
      final books = await ref
          .read(bookRepositoryProvider)
          .searchBooks(query, page: page, size: size);
      return books;
    } catch (e) {
      return [];
    }
  }

  Future<void> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    state = const AsyncValue.loading();
    try {
      final books = await ref
          .read(bookRepositoryProvider)
          .filterBooks(
            status: status,
            difficultyLevel: difficultyLevel,
            category: category,
            page: page,
            size: size,
          );
      state = AsyncValue.data(books);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      await ref.read(bookRepositoryProvider).deleteBook(id);

      final books = state.valueOrNull ?? [];
      state = AsyncValue.data(books.where((book) => book.id != id).toList());

      // If the selected book is being deleted, clear it
      final selectedBook = ref.read(selectedBookProvider).valueOrNull;
      if (selectedBook?.id == id) {
        ref.read(selectedBookProvider.notifier)._clearSelectedBook();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

@riverpod
class SelectedBook extends _$SelectedBook {
  @override
  Future<BookDetail?> build() async {
    return null;
  }

  Future<void> loadBookDetails(String id) async {
    if (id.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final book = await ref.read(bookRepositoryProvider).getBookById(id);
      state = AsyncValue.data(book);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _clearSelectedBook() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<String>> build() async {
    return loadCategories();
  }

  Future<List<String>> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await ref
          .read(bookRepositoryProvider)
          .getAllCategories();
      state = AsyncValue.data(categories);
      return categories;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }
}
