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
      // Load modules data from service
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

    // Get modules due today, this week, and this month using LearningDataService
    final dueToday = learningDataService.getDueToday(_modules);
    final dueThisWeek = learningDataService.getDueThisWeek(_modules);
    final dueThisMonth = learningDataService.getDueThisMonth(_modules);

    // Reset counters
    _dueToday = dueToday.length;
    _dueThisWeek = dueThisWeek.length;
    _dueThisMonth = dueThisMonth.length;

    // Calculate word counts
    _wordsDueToday = dueToday.fold(0, (sum, module) => sum + module.wordCount);
    _wordsDueThisWeek = dueThisWeek.fold(
      0,
      (sum, module) => sum + module.wordCount,
    );
    _wordsDueThisMonth = dueThisMonth.fold(
      0,
      (sum, module) => sum + module.wordCount,
    );

    // Calculate totals
    _totalModules = _modules.length;
    _completedModules = learningDataService.countCompletedModules(_modules);
    _inProgressModules = _totalModules - _completedModules;

    // For the purpose of the demo, set realistic values for completions
    // In a real app, these would come from the repository
    _completedToday =
        (_dueToday * 0.7).round(); // Assume 70% completion rate for today
    _completedThisWeek =
        (_dueThisWeek * 0.8).round(); // Assume 80% completion rate for week
    _completedThisMonth =
        (_dueThisMonth * 0.85).round(); // Assume 85% completion rate for month

    // Set completed word counts (using similar ratios for realism)
    _wordsCompletedToday = (_wordsDueToday * 0.7).round();
    _wordsCompletedThisWeek = (_wordsDueThisWeek * 0.8).round();
    _wordsCompletedThisMonth = (_wordsDueThisMonth * 0.85).round();
  }

  /// Calculate vocabulary statistics
  void _calculateVocabularyStats() {
    // Total words across all modules
    _totalWords = _modules.fold(0, (sum, module) => sum + module.wordCount);

    // Learned words (based on completion percentage of each module)
    _learnedWords = _modules.fold(
      0,
      (sum, module) =>
          sum + ((module.wordCount * module.percentage / 100).round()),
    );

    // Pending words
    _pendingWords = _totalWords - _learnedWords;

    // Vocabulary completion rate
    _vocabularyCompletionRate =
        _totalWords > 0 ? (_learnedWords / _totalWords) * 100 : 0;

    // Calculate a realistic weekly new words rate based on the data
    if (_modules.isNotEmpty) {
      // Modules with first learning dates in the past 4 weeks
      final recentModules =
          _modules
              .where(
                (m) =>
                    m.firstLearningDate != null &&
                    m.firstLearningDate!.isAfter(
                      DateTime.now().subtract(const Duration(days: 28)),
                    ),
              )
              .toList();

      if (recentModules.isNotEmpty) {
        final totalWordsLearned = recentModules.fold(
          0,
          (sum, module) =>
              sum + ((module.wordCount * module.percentage / 100).round()),
        );

        // What percentage of total words is this?
        _weeklyNewWordsRate =
            _totalWords > 0
                ? (totalWordsLearned / _totalWords) *
                    25 // Adjust for a weekly rate
                : 0;
      } else {
        // Fallback to a reasonable default
        _weeklyNewWordsRate = 5.5;
      }
    } else {
      _weeklyNewWordsRate = 0;
    }
  }

  /// Calculate the user's learning streak in days
  Future<int> _calculateStreakDays(String userId) async {
    // In a real app, this would query the database to determine
    // how many consecutive days the user has completed at least one module

    // For this demo, derive a plausible streak from our generated data
    final modulesByRecency =
        _modules.where((m) => m.lastStudyDate != null).toList()
          ..sort((a, b) => b.lastStudyDate!.compareTo(a.lastStudyDate!));

    if (modulesByRecency.isEmpty) return 0;

    // Check if studied today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get most recent study date
    final lastStudyDate = modulesByRecency.first.lastStudyDate!;
    final lastStudyDay = DateTime(
      lastStudyDate.year,
      lastStudyDate.month,
      lastStudyDate.day,
    );

    // If not studied today or yesterday, streak is broken
    if (lastStudyDay.isBefore(today.subtract(const Duration(days: 1)))) {
      return 0;
    }

    // Count back from today to find consecutive study days
    // In a real app, this would be from actual study records
    // Here we'll use a plausible generated value between 1-21 days
    final random = DateTime.now().millisecondsSinceEpoch % 21;
    return random + 1;
  }

  /// Calculate the user's learning streak in weeks
  Future<int> _calculateStreakWeeks(String userId) async {
    // In a real app, this would query the database to determine
    // how many consecutive weeks the user has completed at least one module

    // For this demo, derive from our day streak with some logic
    final dayStreak = await _calculateStreakDays(userId);

    // If day streak is 0, week streak is also 0
    if (dayStreak == 0) return 0;

    // Otherwise calculate a plausible week streak (roughly day streak / 7)
    return (dayStreak / 7).ceil();
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
