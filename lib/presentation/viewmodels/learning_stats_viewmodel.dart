import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// View model for calculating and managing learning statistics
class LearningStatsViewModel extends ChangeNotifier {
  final ProgressRepository progressRepository;
  final LearningDataService learningDataService;

  bool _isLoading = false;
  List<LearningModule> _modules = [];
  String? _errorMessage;

  // Learning statistics
  int _dueToday = 0;
  int _dueThisWeek = 0;
  int _dueThisMonth = 0;

  int _completedToday = 0;
  int _completedThisWeek = 0;
  int _completedThisMonth = 0;

  int _totalModules = 0;
  int _completedModules = 0;
  int _inProgressModules = 0;

  int _streakDays = 0;
  double _averageCompletionRate = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  List<LearningModule> get modules => _modules;
  String? get errorMessage => _errorMessage;

  int get dueToday => _dueToday;
  int get dueThisWeek => _dueThisWeek;
  int get dueThisMonth => _dueThisMonth;

  int get completedToday => _completedToday;
  int get completedThisWeek => _completedThisWeek;
  int get completedThisMonth => _completedThisMonth;

  int get totalModules => _totalModules;
  int get completedModules => _completedModules;
  int get inProgressModules => _inProgressModules;

  int get streakDays => _streakDays;
  double get averageCompletionRate => _averageCompletionRate;

  LearningStatsViewModel({
    required this.progressRepository,
    required this.learningDataService,
  });

  /// Load all learning statistics data
  Future<void> loadLearningStats(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Load modules data
      _modules = await learningDataService.getModules();

      // Calculate statistics
      _calculateStatistics();

      // Load streak days (this could be from a repository in a real app)
      _streakDays = await _calculateStreakDays(userId);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage =
          'An unexpected error occurred while loading learning statistics';
      debugPrint('Error loading learning stats: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Calculate all learning statistics
  void _calculateStatistics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate week range
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Calculate month range
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd =
        (now.month < 12)
            ? DateTime(now.year, now.month + 1, 0)
            : DateTime(now.year + 1, 1, 0);

    // Reset counters
    _dueToday = 0;
    _dueThisWeek = 0;
    _dueThisMonth = 0;
    _completedToday = 0;
    _completedThisWeek = 0;
    _completedThisMonth = 0;

    // Calculate totals
    _totalModules = _modules.length;
    _completedModules = _modules.where((m) => m.percentage >= 100).length;
    _inProgressModules = _totalModules - _completedModules;

    // Calculate due counts
    for (final module in _modules) {
      if (module.nextStudyDate != null) {
        final studyDate = DateTime(
          module.nextStudyDate!.year,
          module.nextStudyDate!.month,
          module.nextStudyDate!.day,
        );

        // Today due
        if (_isSameDay(studyDate, today)) {
          _dueToday++;
        }

        // This week due
        if (studyDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            studyDate.isBefore(weekEnd.add(const Duration(days: 1)))) {
          _dueThisWeek++;
        }

        // This month due
        if (studyDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            studyDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
          _dueThisMonth++;
        }
      }
    }

    // For the purpose of the demo, set some values for completions
    // In a real app, you'd query these from the repository
    _completedToday =
        (_dueToday * 0.7).round(); // Assume 70% completion rate for today
    _completedThisWeek =
        (_dueThisWeek * 0.8).round(); // Assume 80% completion rate for week
    _completedThisMonth =
        (_dueThisMonth * 0.85).round(); // Assume 85% completion rate for month

    // Calculate average completion rate
    _averageCompletionRate =
        _modules.isEmpty
            ? 0.0
            : _modules.map((m) => m.percentage).reduce((a, b) => a + b) /
                _modules.length;
  }

  /// Calculate the user's learning streak in days
  Future<int> _calculateStreakDays(String userId) async {
    // In a real app, this would query the database to determine
    // how many consecutive days the user has completed at least one module

    // For this demo, return a simulated value
    return 9; // Simulated 9-day streak
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Helper to update loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
