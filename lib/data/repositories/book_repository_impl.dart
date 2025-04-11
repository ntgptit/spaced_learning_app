import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/domain/repositories/book_repository.dart';

/// Implementation of the BookRepository interface
class BookRepositoryImpl implements BookRepository {
  final ApiClient _apiClient;

  BookRepositoryImpl(this._apiClient);

  @override
  Future<List<BookSummary>> getAllBooks({int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.books,
        queryParameters: {'page': page, 'size': size},
      );

      final content = response['content'];
      if (content != null && content is List) {
        return content.map((item) => BookSummary.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get books: $e');
    }
  }

  @override
  Future<BookDetail> getBookById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.books}/$id');

      if (response['success'] == true && response['data'] != null) {
        return BookDetail.fromJson(response['data']);
      } else {
        throw NotFoundException('Book not found: ${response['message']}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get book: $e');
    }
  }

  @override
  Future<List<BookSummary>> searchBooks(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.bookSearch,
        queryParameters: {'query': query, 'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> bookList = response['content'];
        return bookList.map((item) => BookSummary.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to search books: $e');
    }
  }

  @override
  Future<List<String>> getAllCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bookCategories);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> categoryList = response['data'];
        return categoryList.map((item) => item.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get categories: $e');
    }
  }

  @override
  Future<List<BookSummary>> filterBooks({
    BookStatus? status,
    DifficultyLevel? difficultyLevel,
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'size': size};

      if (status != null) {
        queryParams['status'] = status.toString().split('.').last.toUpperCase();
      }

      if (difficultyLevel != null) {
        queryParams['difficultyLevel'] =
            difficultyLevel.toString().split('.').last.toUpperCase();
      }

      if (category != null) {
        queryParams['category'] = category;
      }

      final response = await _apiClient.get(
        ApiEndpoints.bookFilter,
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> bookList = response['content'];
        return bookList.map((item) => BookSummary.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to filter books: $e');
    }
  }

  // @override
  // Future<BookDetail> createBook({
  //   required String name,
  //   String? description,
  //   BookStatus? status,
  //   DifficultyLevel? difficultyLevel,
  //   String? category,
  // }) async {
  //   try {
  //     final data = <String, dynamic>{'name': name};

  //     if (description != null) {
  //       data['description'] = description;
  //     }

  //     if (status != null) {
  //       data['status'] = status.toString().split('.').last.toUpperCase();
  //     }

  //     if (difficultyLevel != null) {
  //       data['difficultyLevel'] =
  //           difficultyLevel.toString().split('.').last.toUpperCase();
  //     }

  //     if (category != null) {
  //       data['category'] = category;
  //     }

  //     final response = await _apiClient.post(ApiEndpoints.books, data: data);

  //     if (response['success'] == true && response['data'] != null) {
  //       return BookDetail.fromJson(response['data']);
  //     } else {
  //       throw BadRequestException(
  //         'Failed to create book: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to create book: $e');
  //   }
  // }

  // @override
  // Future<BookDetail> updateBook(
  //   String id, {
  //   String? name,
  //   String? description,
  //   BookStatus? status,
  //   DifficultyLevel? difficultyLevel,
  //   String? category,
  // }) async {
  //   try {
  //     final data = <String, dynamic>{};

  //     if (name != null) {
  //       data['name'] = name;
  //     }

  //     if (description != null) {
  //       data['description'] = description;
  //     }

  //     if (status != null) {
  //       data['status'] = status.toString().split('.').last.toUpperCase();
  //     }

  //     if (difficultyLevel != null) {
  //       data['difficultyLevel'] =
  //           difficultyLevel.toString().split('.').last.toUpperCase();
  //     }

  //     if (category != null) {
  //       data['category'] = category;
  //     }

  //     final response = await _apiClient.put(
  //       '${ApiEndpoints.books}/$id',
  //       data: data,
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return BookDetail.fromJson(response['data']);
  //     } else {
  //       throw BadRequestException(
  //         'Failed to update book: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to update book: $e');
  //   }
  // }

  @override
  Future<void> deleteBook(String id) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.books}/$id');

      if (response == null || response['success'] != true) {
        throw BadRequestException(
          'Failed to delete book: ${response?['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to delete book: $e');
    }
  }
}
