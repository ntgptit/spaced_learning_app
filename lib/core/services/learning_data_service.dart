import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// Service để lấy và xử lý dữ liệu học tập
class LearningDataService {
  /// Lấy danh sách module học tập mẫu
  Future<List<LearningModule>> getModules() async {
    // Giả lập chờ lấy dữ liệu
    await Future.delayed(const Duration(milliseconds: 800));

    // Dữ liệu mẫu
    return [
      LearningModule(
        id: '1',
        book: 'Book1',
        subject: 'Vitamin_Book1_Chapter1-1 + 1-2',
        wordCount: 76,
        cyclesStudied: CycleStudied.secondReview,
        firstLearningDate: DateTime(2024, 12, 8),
        percentage: 96,
        nextStudyDate: DateTime(2025, 4, 20),
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
        nextStudyDate: DateTime(2025, 3, 15),
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
        nextStudyDate: DateTime(2025, 2, 28),
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
        nextStudyDate: DateTime(2025, 2, 28),
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
        nextStudyDate: DateTime(2025, 3, 2),
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
        nextStudyDate: DateTime(2025, 2, 27),
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
        nextStudyDate: DateTime(2025, 3, 24),
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
        nextStudyDate: DateTime(2025, 2, 22),
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
        nextStudyDate: DateTime(2025, 2, 26),
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
        nextStudyDate: DateTime(2025, 2, 25),
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

  /// Lọc các module theo sách
  List<LearningModule> filterByBook(List<LearningModule> modules, String book) {
    if (book == 'All') {
      return modules;
    }
    return modules.where((module) => module.book == book).toList();
  }

  /// Lọc các module theo ngày học tiếp theo
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

  /// Kiểm tra xem hai ngày có cùng ngày không (bỏ qua giờ phút giây)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Đếm số module sắp đến hạn học
  int countDueModules(List<LearningModule> modules, {int daysThreshold = 7}) {
    final today = DateTime.now();
    final dueDate = today.add(Duration(days: daysThreshold));

    return modules
        .where(
          (module) =>
              module.nextStudyDate != null &&
              module.nextStudyDate!.isAfter(today) &&
              module.nextStudyDate!.isBefore(dueDate),
        )
        .length;
  }

  /// Đếm số module đã hoàn thành
  int countCompletedModules(List<LearningModule> modules) {
    return modules.where((module) => module.percentage == 100).length;
  }

  /// Lấy danh sách các sách duy nhất từ các module
  List<String> getUniqueBooks(List<LearningModule> modules) {
    final books = modules.map((module) => module.book).toSet().toList();
    books.sort();
    return ['All', ...books];
  }

  /// Giả lập xuất dữ liệu
  Future<bool> exportData() async {
    // Giả lập chờ xuất dữ liệu
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
