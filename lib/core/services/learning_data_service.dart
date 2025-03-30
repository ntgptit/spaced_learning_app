import 'package:spaced_learning_app/domain/models/learning_module.dart';

/// Service interface for learning data operations
abstract class LearningDataService {
  /// Get all learning modules
  Future<List<LearningModule>> getModules();

  /// Filter modules by book
  List<LearningModule> filterByBook(List<LearningModule> modules, String book);

  /// Filter modules by date
  List<LearningModule> filterByDate(
    List<LearningModule> modules,
    DateTime date,
  );

  /// Check if two dates represent the same day
  bool isSameDay(DateTime date1, DateTime date2);

  /// Count modules that are due for study within the given threshold of days
  int countDueModules(List<LearningModule> modules, {int daysThreshold = 7});

  /// Count modules that are 100% complete
  int countCompletedModules(List<LearningModule> modules);

  /// Get list of unique book names from the modules
  List<String> getUniqueBooks(List<LearningModule> modules);

  /// Export learning data (for reports, etc.)
  Future<bool> exportData();

  /// Get active modules count (those with less than 100% completion)
  int getActiveModulesCount(List<LearningModule> modules);

  /// Get all modules due today
  List<LearningModule> getDueToday(List<LearningModule> modules);

  /// Get all modules due this week
  List<LearningModule> getDueThisWeek(List<LearningModule> modules);

  /// Get all modules due this month
  List<LearningModule> getDueThisMonth(List<LearningModule> modules);
}
