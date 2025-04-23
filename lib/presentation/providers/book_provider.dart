// lib/presentation/providers/book_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

import '../../core/di/providers.dart';

part 'book_provider.g.dart';

@riverpod
class Books extends _$Books {
  @override
  Future<List<BookSummary>> build({int page = 0, int size = 20}) async {
    return _fetchBooks(page, size);
  }

  Future<List<BookSummary>> _fetchBooks(int page, int size) async {
    final repository = ref.read(bookRepositoryProvider);
    return repository.getAllBooks(page: page, size: size);
  }

  Future<void> refreshBooks({int page = 0, int size = 20}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchBooks(page, size));
  }

  Future<void> searchBooks(String query, {int page = 0, int size = 20}) async {
    if (query.isEmpty) {
      return refreshBooks(page: page, size: size);
    }

    state = const AsyncValue.loading();
    final repository = ref.read(bookRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.searchBooks(query, page: page, size: size),
    );
  }

  Future<void> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(bookRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.filterBooks(
        status: status,
        difficultyLevel: difficultyLevel,
        category: category,
        page: page,
        size: size,
      ),
    );
  }

  Future<void> deleteBook(String id) async {
    final repository = ref.read(bookRepositoryProvider);
    await repository.deleteBook(id);

    // Refresh the book list after deletion
    final currentBooks = state.valueOrNull ?? [];
    state = AsyncValue.data(
      currentBooks.where((book) => book.id != id).toList(),
    );
  }
}

@riverpod
Future<BookDetail> bookDetail(BookDetailRef ref, String id) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBookById(id);
}

@riverpod
Future<List<String>> bookCategories(BookCategoriesRef ref) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getAllCategories();
}
