import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// Implementation of the learning data service
class LearningDataServiceImpl implements LearningDataService {
  @override
  Future<List<LearningModule>> getModules() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Sample data
    return [
      LearningModule(
        id: '1',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter1-1 + 1-2',
        wordCount: 76,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 8),
        percentage: 96,
        nextStudyDate: DateTime.now(), // Due today
        taskCount: 1,
      ),
      LearningModule(
        id: '2',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter1-3: Single Final Consonants',
        wordCount: 52,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 9),
        percentage: 98,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 2),
        ), // Due this week
        taskCount: 1,
      ),
      LearningModule(
        id: '3',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter1-3: Double Final Consonants',
        wordCount: 12,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 10),
        percentage: 100,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 6),
        ), // Due this week
        taskCount: 3,
      ),
      LearningModule(
        id: '4',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter2-1: Vocabulary',
        wordCount: 31,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 11),
        percentage: 94,
        nextStudyDate: DateTime.now(), // Due today
        taskCount: 3,
      ),
      LearningModule(
        id: '5',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter2-2: Vocabulary',
        wordCount: 29,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 12),
        percentage: 100,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 10),
        ), // Due this month
        taskCount: 1,
      ),
      LearningModule(
        id: '19',
        book: 'Book2',
        subject: 'Vitamin_Book2_Chapter1-1: Vocabulary',
        wordCount: 74,
        cyclesStudied: CycleStudied.firstTime,
        firstLearningDate: DateTime(2024, 12, 26),
        percentage: 86,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 15),
        ), // Due this month
        taskCount: 1,
      ),
      LearningModule(
        id: '20',
        book: 'Book2',
        subject: 'Vitamin_Book2_Chapter1-2: Vocabulary',
        wordCount: 47,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 27),
        percentage: 85,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 23),
        ), // Due this month
        taskCount: 1,
      ),
      LearningModule(
        id: '34',
        book: 'Book3',
        subject: 'Vitamin_Book3_Chapter1-1: Vocabulary',
        wordCount: 108,
        cyclesStudied: null,
        firstLearningDate: null,
        percentage: 100,
        nextStudyDate: null,
        taskCount: null,
      ),
      LearningModule(
        id: '35',
        book: 'Book3',
        subject: 'Vitamin_Book3_Chapter1-2: Vocabulary',
        wordCount: 62,
        cyclesStudied: null,
        firstLearningDate: null,
        percentage: 100,
        nextStudyDate: null,
        taskCount: null,
      ),
      LearningModule(
        id: '38',
        book: 'Book3',
        subject: 'Vitamin_Book3_Chapter2-1: Korean - Honorifics',
        wordCount: 18,
        cyclesStudied: CycleStudied.firstTime,
        firstLearningDate: DateTime(2025, 1, 2),
        percentage: 100,
        nextStudyDate: DateTime.now(), // Due today
        taskCount: 4,
      ),
      LearningModule(
        id: '40',
        book: 'Additional',
        subject: 'Additional_20240814: 대인 관계',
        wordCount: 60,
        cyclesStudied: null,
        firstLearningDate: null,
        percentage: 100,
        nextStudyDate: null,
        taskCount: null,
      ),
      LearningModule(
        id: '56',
        book: 'Duyen선생님_중급1',
        subject: 'Section 1: 대학 생활',
        wordCount: 40,
        cyclesStudied: CycleStudied.firstTime,
        firstLearningDate: DateTime(2024, 12, 31),
        percentage: 97,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 3),
        ), // Due this week
        taskCount: 3,
      ),
      LearningModule(
        id: '57',
        book: 'THTH Book2',
        subject: 'Section 1: 관계 +방문 + 인사말',
        wordCount: 46,
        cyclesStudied: CycleStudied.firstTime,
        firstLearningDate: DateTime(2025, 1, 1),
        percentage: 100,
        nextStudyDate: DateTime.now().add(
          const Duration(days: 4),
        ), // Due this week
        taskCount: 4,
      ),
      LearningModule(
        id: '61',
        book: '[OJT_Korea_2024]',
        subject: 'Section 1: Cho đi và nhận lại',
        wordCount: 116,
        cyclesStudied: null,
        firstLearningDate: null,
        percentage: 100,
        nextStudyDate: null,
        taskCount: null,
      ),
    ];
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
