import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// Enhanced view model for calculating and managing comprehensive learning statistics
class EnhancedLearningStatsViewModel extends ChangeNotifier {
  final ProgressRepository progressRepository;
  final LearningDataService learningDataService;

  bool _isLoading = false;
  List<LearningModule> _modules = [];
  String? _errorMessage;

  // Due learning sessions
  int _dueToday = 0;
  int _dueThisWeek = 0;
  int _dueThisMonth = 0;

  // Word counts for due sessions
  int _wordsDueToday = 0;
  int _wordsDueThisWeek = 0;
  int _wordsDueThisMonth = 0;

  // Completed sessions
  int _completedToday = 0;
  int _completedThisWeek = 0;
  int _completedThisMonth = 0;

  // Word counts for completed sessions
  int _wordsCompletedToday = 0;
  int _wordsCompletedThisWeek = 0;
  int _wordsCompletedThisMonth = 0;

  // Module counts
  int _totalModules = 0;
  int _completedModules = 0;
  int _inProgressModules = 0;

  // Learning streaks
  int _streakDays = 0;
  int _streakWeeks = 0;

  // Vocabulary statistics
  int _totalWords = 0;
  int _learnedWords = 0;
  int _pendingWords = 0;
  double _vocabularyCompletionRate = 0.0;
  double _weeklyNewWordsRate = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  List<LearningModule> get modules => _modules;
  String? get errorMessage => _errorMessage;

  // Due session getters
  int get dueToday => _dueToday;
  int get dueThisWeek => _dueThisWeek;
  int get dueThisMonth => _dueThisMonth;

  // Due words getters
  int get wordsDueToday => _wordsDueToday;
  int get wordsDueThisWeek => _wordsDueThisWeek;
  int get wordsDueThisMonth => _wordsDueThisMonth;

  // Completed session getters
  int get completedToday => _completedToday;
  int get completedThisWeek => _completedThisWeek;
  int get completedThisMonth => _completedThisMonth;

  // Completed words getters
  int get wordsCompletedToday => _wordsCompletedToday;
  int get wordsCompletedThisWeek => _wordsCompletedThisWeek;
  int get wordsCompletedThisMonth => _wordsCompletedThisMonth;

  // Module count getters
  int get totalModules => _totalModules;
  int get completedModules => _completedModules;
  int get inProgressModules => _inProgressModules;

  // Streak getters
  int get streakDays => _streakDays;
  int get streakWeeks => _streakWeeks;

  // Vocabulary getters
  int get totalWords => _totalWords;
  int get learnedWords => _learnedWords;
  int get pendingWords => _pendingWords;
  double get vocabularyCompletionRate => _vocabularyCompletionRate;
  double get weeklyNewWordsRate => _weeklyNewWordsRate;

  EnhancedLearningStatsViewModel({
    required this.progressRepository,
    required this.learningDataService,
  });

  /// Load all learning statistics data with enhanced metrics
  Future<void> loadLearningStats(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Load modules data
      _modules = await learningDataService.getModules();

      // Calculate statistics
      _calculateStatistics();

      // Load streak data
      _streakDays = await _calculateStreakDays(userId);
      _streakWeeks = await _calculateStreakWeeks(userId);

      // Calculate vocabulary statistics
      _calculateVocabularyStats();
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
    _wordsDueToday = 0;
    _wordsDueThisWeek = 0;
    _wordsDueThisMonth = 0;

    // Calculate totals
    _totalModules = _modules.length;
    _completedModules = _modules.where((m) => m.percentage >= 100).length;
    _inProgressModules = _totalModules - _completedModules;

    // Calculate due counts and word counts
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
          _wordsDueToday += module.wordCount;
        }

        // This week due
        if (studyDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            studyDate.isBefore(weekEnd.add(const Duration(days: 1)))) {
          _dueThisWeek++;
          _wordsDueThisWeek += module.wordCount;
        }

        // This month due
        if (studyDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            studyDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
          _dueThisMonth++;
          _wordsDueThisMonth += module.wordCount;
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

    // Set completed word counts (using similar ratios for demo)
    _wordsCompletedToday = (_wordsDueToday * 0.7).round();
    _wordsCompletedThisWeek = (_wordsDueThisWeek * 0.8).round();
    _wordsCompletedThisMonth = (_wordsDueThisMonth * 0.85).round();
  }

  /// Calculate vocabulary statistics
  void _calculateVocabularyStats() {
    // Total words across all modules
    _totalWords = _modules.fold(0, (sum, module) => sum + module.wordCount);

    // Learned words (from completed modules)
    _learnedWords = _modules
        .where((m) => m.percentage >= 100)
        .fold(0, (sum, module) => sum + module.wordCount);

    // Pending words
    _pendingWords = _totalWords - _learnedWords;

    // Vocabulary completion rate
    _vocabularyCompletionRate =
        _totalWords > 0 ? (_learnedWords / _totalWords) * 100 : 0;

    // Weekly new words rate (what percentage of words are learned per week)
    // For demo purposes, we'll use a fixed value or calculate based on recent completion
    _weeklyNewWordsRate = 8.5; // Simulated 8.5% of new vocabulary per week
  }

  /// Calculate the user's learning streak in days
  Future<int> _calculateStreakDays(String userId) async {
    // In a real app, this would query the database to determine
    // how many consecutive days the user has completed at least one module

    // For this demo, return a simulated value
    return 14; // Simulated 14-day streak
  }

  /// Calculate the user's learning streak in weeks
  Future<int> _calculateStreakWeeks(String userId) async {
    // In a real app, this would query the database to determine
    // how many consecutive weeks the user has completed at least one module

    // For this demo, return a simulated value
    return 3; // Simulated 3-week streak
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
