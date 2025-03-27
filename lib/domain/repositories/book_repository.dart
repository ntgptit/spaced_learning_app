import 'package:spaced_learning_app/domain/models/book.dart';

/// Repository interface for book operations
abstract class BookRepository {
  /// Get all books with pagination
  Future<List<BookSummary>> getAllBooks({int page = 0, int size = 20});

  /// Get book by ID
  Future<BookDetail> getBookById(String id);

  /// Search books by name
  Future<List<BookSummary>> searchBooks(
    String query, {
    int page = 0,
    int size = 20,
  });

  /// Get all unique book categories
  Future<List<String>> getAllCategories();

  /// Filter books by status, difficulty level, and category
  Future<List<BookSummary>> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  });

  /// Create a new book (admin only)
  Future<BookDetail> createBook({
    required String name,
    String? description,
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
  });

  /// Update a book (admin only)
  Future<BookDetail> updateBook(
    String id, {
    String? name,
    String? description,
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
  });

  /// Delete a book by ID (admin only)
  Future<void> deleteBook(String id);
}
