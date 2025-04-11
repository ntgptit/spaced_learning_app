import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/repositories/book_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class BookViewModel extends BaseViewModel {
  final BookRepository bookRepository;

  List<BookSummary> _books = [];
  BookDetail? _selectedBook;
  List<String> _categories = [];

  BookViewModel({required this.bookRepository});

  List<BookSummary> get books => _books;
  BookDetail? get selectedBook => _selectedBook;
  List<String> get categories => _categories;

  Future<void> loadBooks({int page = 0, int size = 20}) async {
    await safeCall(
      action: () async {
        _books = await bookRepository.getAllBooks(page: page, size: size);
        return _books;
      },
      errorPrefix: 'Failed to load books',
    );
  }

  Future<void> loadBookDetails(String id) async {
    await safeCall(
      action: () async {
        _selectedBook = await bookRepository.getBookById(id);
        return _selectedBook;
      },
      errorPrefix: 'Failed to load book details',
    );
  }

  Future<List<BookSummary>> searchBooks(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    final result = await safeCall<List<BookSummary>>(
      action: () => bookRepository.searchBooks(query, page: page, size: size),
      errorPrefix: 'Failed to search books',
    );
    return result ?? [];
  }

  Future<void> loadCategories() async {
    await safeCall(
      action: () async {
        _categories = await bookRepository.getAllCategories();
        return _categories;
      },
      errorPrefix: 'Failed to load categories',
    );
  }

  Future<void> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    await safeCall(
      action: () async {
        _books = await bookRepository.filterBooks(
          status: status,
          difficultyLevel: difficultyLevel,
          category: category,
          page: page,
          size: size,
        );
        return _books;
      },
      errorPrefix: 'Failed to filter books',
    );
  }





  Future<bool> deleteBook(String id) async {
    final result = await safeCall<bool>(
      action: () async {
        await bookRepository.deleteBook(id);

        if (_selectedBook?.id == id) {
          _selectedBook = null;
        }

        _books = _books.where((book) => book.id != id).toList();
        return true;
      },
      errorPrefix: 'Failed to delete book',
    );
    return result ?? false;
  }
}
