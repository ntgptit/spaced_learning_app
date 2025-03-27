import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/repositories/book_repository.dart';

/// View model for book operations
class BookViewModel extends ChangeNotifier {
  final BookRepository bookRepository;

  bool _isLoading = false;
  List<BookSummary> _books = [];
  BookDetail? _selectedBook;
  List<String> _categories = [];
  String? _errorMessage;

  BookViewModel({required this.bookRepository});

  // Getters
  bool get isLoading => _isLoading;
  List<BookSummary> get books => _books;
  BookDetail? get selectedBook => _selectedBook;
  List<String> get categories => _categories;
  String? get errorMessage => _errorMessage;

  /// Load all books with pagination
  Future<void> loadBooks({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _books = await bookRepository.getAllBooks(page: page, size: size);
      print('Books: ${_books.length}');
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load book details by ID
  Future<void> loadBookDetails(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedBook = await bookRepository.getBookById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Search books by name
  Future<List<BookSummary>> searchBooks(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final results = await bookRepository.searchBooks(
        query,
        page: page,
        size: size,
      );
      return results;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return [];
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return [];
    } finally {
      _setLoading(false);
    }
  }

  /// Load all book categories
  Future<void> loadCategories() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _categories = await bookRepository.getAllCategories();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Filter books by status, difficulty level, and category
  Future<void> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _books = await bookRepository.filterBooks(
        status: status,
        difficultyLevel: difficultyLevel,
        category: category,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new book (admin only)
  Future<BookDetail?> createBook({
    required String name,
    String? description,
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final book = await bookRepository.createBook(
        name: name,
        description: description,
        status: status,
        difficultyLevel: difficultyLevel,
        category: category,
      );
      return book;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update a book (admin only)
  Future<BookDetail?> updateBook(
    String id, {
    String? name,
    String? description,
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final book = await bookRepository.updateBook(
        id,
        name: name,
        description: description,
        status: status,
        difficultyLevel: difficultyLevel,
        category: category,
      );

      if (_selectedBook?.id == id) {
        _selectedBook = book;
      }

      return book;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a book (admin only)
  Future<bool> deleteBook(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await bookRepository.deleteBook(id);

      if (_selectedBook?.id == id) {
        _selectedBook = null;
      }

      _books = _books.where((book) => book.id != id).toList();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
