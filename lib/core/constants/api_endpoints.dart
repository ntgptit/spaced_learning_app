import 'package:spaced_learning_app/core/constants/app_constants.dart';

/// API endpoint constants
class ApiEndpoints {
  static String basePath = AppConstants.baseUrl + AppConstants.apiPrefix;

  // Auth related endpoints
  static final String login = '$basePath/auth/login';
  static final String register = '$basePath/auth/register';
  static final String refreshToken = '$basePath/auth/refresh-token';
  static final String validateToken = '$basePath/auth/validate';

  // User related endpoints
  static final String currentUser = '$basePath/users/me';
  static final String users = '$basePath/users';

  // Book related endpoints
  static final String books = '$basePath/books';
  static final String bookCategories = '$basePath/books/categories';
  static final String bookSearch = '$basePath/books/search';
  static final String bookFilter = '$basePath/books/filter';

  // Module related endpoints
  static final String modules = '$basePath/modules';
  static String modulesByBook(String bookId) =>
      '$basePath/modules/book/$bookId';
  static String allModulesByBook(String bookId) =>
      '$basePath/modules/book/$bookId/all';
  static String nextModuleNumber(String bookId) =>
      '$basePath/modules/book/$bookId/next-number';

  // Progress related endpoints
  static final String progress = '$basePath/progress';
  static String progressByUser(String userId) =>
      '$basePath/progress/user/$userId';
  static String progressByUserAndBook(String userId, String bookId) =>
      '$basePath/progress/user/$userId/book/$bookId';
  static String progressByUserAndModule(String userId, String moduleId) =>
      '$basePath/progress/user/$userId/module/$moduleId';
  static String dueProgress(String userId) =>
      '$basePath/progress/user/$userId/due';

  // Repetition related endpoints
  static final String repetitions = '$basePath/repetitions';
  static String repetitionsByProgress(String progressId) =>
      '$basePath/repetitions/progress/$progressId';
  static String repetitionSchedule(String progressId) =>
      '$basePath/repetitions/progress/$progressId/schedule';
  static String dueRepetitions(String userId) =>
      '$basePath/repetitions/user/$userId/due';
  static String repetitionByOrder(String progressId, String order) =>
      '$basePath/repetitions/progress/$progressId/order/$order';
}
