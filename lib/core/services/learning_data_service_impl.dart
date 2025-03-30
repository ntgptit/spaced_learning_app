import 'dart:math';

import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// Implementation of the learning data service with realistic data
class LearningDataServiceImpl implements LearningDataService {
  // Cache for loaded modules to reduce repeated data generation
  List<LearningModule>? _cachedModules;

  @override
  Future<List<LearningModule>> getModules() async {
    // Return cached data if available
    if (_cachedModules != null) {
      return _cachedModules!;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate realistic sample data
    final now = DateTime.now();

    // Book categories
    final books = [
      'Korean Grammar in Use',
      'TOPIK Study Guide',
      'Korean Vocabulary Practice',
      'Korean Reading Comprehension',
      'Korean Writing Workbook',
      'Basic Korean Phrases',
      'Business Korean',
    ];

    // Subject prefixes to create realistic module names
    final subjectPrefixes = [
      'Chapter',
      'Section',
      'Unit',
      'Lesson',
      'Topic',
      'Part',
      'Module',
    ];

    // Subject topics for more realistic names
    final subjectTopics = [
      'Present Tense',
      'Past Tense',
      'Future Tense',
      'Honorifics',
      'Formal Speech',
      'Casual Speech',
      'Question Forms',
      'Counters and Numbers',
      'Time Expressions',
      'Conjunctions',
      'Adjectives',
      'Adverbs',
      'Locations and Directions',
      'Family Vocabulary',
      'Food and Dining',
      'Travel and Transportation',
      'Workplace Vocabulary',
      'Educational Terms',
      'Health and Medical',
      'Shopping and Commerce',
    ];

    // Generate a mix of modules with varied completion status
    final Random random = Random();
    final List<LearningModule> modules = [];

    // Generate about 30 modules
    for (int i = 1; i <= 30; i++) {
      final book = books[random.nextInt(books.length)];
      final prefix = subjectPrefixes[random.nextInt(subjectPrefixes.length)];
      final topic = subjectTopics[random.nextInt(subjectTopics.length)];
      final chapterNum = random.nextInt(10) + 1;
      final sectionNum = random.nextInt(5) + 1;

      // Create module subject
      final subject = '$prefix $chapterNum-$sectionNum: $topic';

      // Randomize word count between 20 and 150
      final wordCount = 20 + random.nextInt(130);

      // Randomize completion percentage (higher chance of completion for lower indices)
      int percentage;
      if (i <= 10) {
        percentage = 70 + random.nextInt(31); // 70-100%
      } else if (i <= 20) {
        percentage = 30 + random.nextInt(71); // 30-100%
      } else {
        percentage = random.nextInt(101); // 0-100%
      }

      // Determine cycle studied based on percentage
      CycleStudied? cyclesStudied;
      if (percentage >= 95) {
        cyclesStudied =
            [
              CycleStudied.moreThanThreeReviews,
              CycleStudied.thirdReview,
              CycleStudied.secondReview,
            ][random.nextInt(3)];
      } else if (percentage >= 70) {
        cyclesStudied =
            [CycleStudied.secondReview, CycleStudied.firstReview][random
                .nextInt(2)];
      } else if (percentage >= 30) {
        cyclesStudied = CycleStudied.firstTime;
      } else if (percentage > 0) {
        cyclesStudied = CycleStudied.firstTime;
      }

      // Determine dates
      DateTime? firstLearningDate;
      if (percentage > 0) {
        // Started between 1 and 90 days ago
        firstLearningDate = now.subtract(
          Duration(days: 1 + random.nextInt(90)),
        );
      }

      // Only modules in progress have next study dates
      DateTime? nextStudyDate;
      if (percentage > 0 && percentage < 100) {
        // Due between 3 days ago and 30 days from now
        nextStudyDate = now.add(Duration(days: -3 + random.nextInt(34)));
      }

      // Task count is only relevant for active modules
      int? taskCount;
      if (percentage > 0 && percentage < 100) {
        taskCount = 1 + random.nextInt(5);
      }

      // Create module with all data
      modules.add(
        LearningModule(
          id: 'module_$i',
          book: book,
          subject: subject,
          wordCount: wordCount,
          cyclesStudied: cyclesStudied,
          firstLearningDate: firstLearningDate,
          percentage: percentage,
          nextStudyDate: nextStudyDate,
          taskCount: taskCount,
          learnedWords: (wordCount * percentage / 100).round(),
          lastStudyDate: firstLearningDate?.add(
            Duration(days: random.nextInt(30)),
          ),
          studyHistory:
              percentage > 0
                  ? _generateRandomStudyHistory(
                    firstLearningDate,
                    now,
                    5 + random.nextInt(20),
                  )
                  : null,
        ),
      );
    }

    // Cache for future use
    _cachedModules = modules;
    return modules;
  }

  /// Generate a random history of study dates
  List<DateTime> _generateRandomStudyHistory(
    DateTime? start,
    DateTime end,
    int count,
  ) {
    if (start == null) return [];

    final random = Random();
    final result = <DateTime>[];

    // Ensure the list isn't too large
    count = min(count, 30);

    final daysBetween = end.difference(start).inDays;
    if (daysBetween <= 0) return [];

    // Generate random dates between start and end
    for (int i = 0; i < count; i++) {
      final daysToAdd = random.nextInt(daysBetween);
      result.add(start.add(Duration(days: daysToAdd)));
    }

    // Sort chronologically
    result.sort();
    return result;
  }

  @override
  List<LearningModule> filterByBook(List<LearningModule> modules, String book) {
    if (book == 'All') {
      return modules;
    }
    return modules.where((module) => module.book == book).toList();
  }

  @override
  List<LearningModule> filterByDate(
    List<LearningModule> modules,
    DateTime date,
  ) {
    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              isSameDay(module.nextStudyDate!, date),
        )
        .toList();
  }

  @override
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  int countDueModules(List<LearningModule> modules, {int daysThreshold = 7}) {
    final today = DateTime.now();
    final dueDate = today.add(Duration(days: daysThreshold));

    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              module.nextStudyDate!.isAfter(
                today.subtract(const Duration(days: 1)),
              ) &&
              module.nextStudyDate!.isBefore(dueDate),
        )
        .length;
  }

  @override
  int countCompletedModules(List<LearningModule> modules) {
    return modules.where((module) => module.percentage == 100).length;
  }

  @override
  List<String> getUniqueBooks(List<LearningModule> modules) {
    final books = modules.map((module) => module.book).toSet().toList();
    books.sort();
    return ['All', ...books];
  }

  @override
  Future<bool> exportData() async {
    // Simulate export process
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  int getActiveModulesCount(List<LearningModule> modules) {
    return modules.where((module) => module.percentage < 100).length;
  }

  @override
  List<LearningModule> getDueToday(List<LearningModule> modules) {
    final today = DateTime.now();
    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              isSameDay(module.nextStudyDate!, today),
        )
        .toList();
  }

  @override
  List<LearningModule> getDueThisWeek(List<LearningModule> modules) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              module.nextStudyDate!.isAfter(
                weekStart.subtract(const Duration(days: 1)),
              ) &&
              module.nextStudyDate!.isBefore(
                weekEnd.add(const Duration(days: 1)),
              ),
        )
        .toList();
  }

  @override
  List<LearningModule> getDueThisMonth(List<LearningModule> modules) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd =
        (now.month < 12)
            ? DateTime(now.year, now.month + 1, 0)
            : DateTime(now.year + 1, 1, 0);

    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              module.nextStudyDate!.isAfter(
                monthStart.subtract(const Duration(days: 1)),
              ) &&
              module.nextStudyDate!.isBefore(
                monthEnd.add(const Duration(days: 1)),
              ),
        )
        .toList();
  }
}
