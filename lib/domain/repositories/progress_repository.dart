import 'package:spaced_learning_app/domain/models/progress.dart';

/// Repository interface for module progress operations
abstract class ProgressRepository {
  /// Get all progress records with pagination
  Future<List<ProgressSummary>> getAllProgress({int page = 0, int size = 20});

  /// Get progress by ID
  Future<ProgressDetail> getProgressById(String id);

  /// Get progress records by user ID
  Future<List<ProgressSummary>> getProgressByUserId(
    String userId, {
    int page = 0,
    int size = 20,
  });

  /// Get progress records by module ID
  Future<List<ProgressSummary>> getProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  });

  /// Get progress records by user ID and book ID
  Future<List<ProgressSummary>> getProgressByUserAndBook(
    String userId,
    String bookId, {
    int page = 0,
    int size = 20,
  });

  /// Get progress for a specific user and module
  Future<ProgressDetail> getProgressByUserAndModule(
    String userId,
    String moduleId,
  );

  /// Get progress for current user and a specific module
  Future<ProgressDetail?> getCurrentUserProgressByModule(String moduleId);

  /// Get progress records due for study
  Future<List<ProgressSummary>> getDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  });

  /// Create a new progress record
  Future<ProgressDetail> createProgress({
    required String moduleId,
    required String userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  });

  /// Update a progress record
  Future<ProgressDetail> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  });

  /// Delete a progress record
  Future<void> deleteProgress(String id);
}
