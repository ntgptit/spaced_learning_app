// lib/domain/repositories/learning_progress_repository.dart
import 'package:spaced_learning_app/domain/models/learning_module.dart';

/// Repository interface for learning progress operations
abstract class LearningProgressRepository {
  /// Get all learning modules
  Future<List<LearningModule>> getAllModules();

  /// Get modules that are due within the specified threshold of days
  Future<List<LearningModule>> getDueModules(int daysThreshold);

  /// Get modules that are completed (100% progress)
  Future<List<LearningModule>> getCompletedModules();

  /// Get all unique book names
  Future<List<String>> getUniqueBooks();

  /// Export learning data
  Future<Map<String, dynamic>> exportData();

  /// Get book statistics
  Future<Map<String, dynamic>> getBookStats(String bookName);

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats({
    String? book,
    DateTime? date,
  });
}
