// lib/presentation/providers/learning_progress_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';

import '../../core/di/providers.dart';

part 'learning_progress_provider.g.dart';

@riverpod
class LearningProgress extends _$LearningProgress {
  @override
  Future<List<LearningModule>> build() async {
    return _fetchModules();
  }

  Future<List<LearningModule>> _fetchModules() async {
    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getModules();
  }

  Future<void> refreshModules() async {
    state = const AsyncValue.loading();

    final dataService = ref.read(learningDataServiceProvider);
    dataService.resetCache(); // Clear the cache to get fresh data

    state = await AsyncValue.guard(() => _fetchModules());
  }

  List<LearningModule> filterByBook(String book) {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return [];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.filterByBook(modules, book);
  }

  List<LearningModule> filterByDate(DateTime date) {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return [];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.filterByDate(modules, date);
  }

  List<String> getUniqueBooks() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return ['All'];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getUniqueBooks(modules);
  }

  Future<bool> exportData() async {
    final dataService = ref.read(learningDataServiceProvider);
    return dataService.exportData();
  }

  int countDueModules({int daysThreshold = 7}) {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return 0;

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.countDueModules(modules, daysThreshold: daysThreshold);
  }

  int countCompletedModules() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return 0;

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.countCompletedModules(modules);
  }

  int getActiveModulesCount() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return 0;

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getActiveModulesCount(modules);
  }

  List<LearningModule> getDueToday() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return [];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getDueToday(modules);
  }

  List<LearningModule> getDueThisWeek() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return [];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getDueThisWeek(modules);
  }

  List<LearningModule> getDueThisMonth() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return [];

    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getDueThisMonth(modules);
  }

  Future<Map<String, dynamic>> getDashboardStats({
    String? book,
    DateTime? date,
  }) async {
    final dataService = ref.read(learningDataServiceProvider);
    return dataService.getDashboardStats(book: book, date: date);
  }
}

@riverpod
Future<List<String>> uniqueBooks(UniqueBooksRef ref) async {
  final dataService = ref.watch(learningDataServiceProvider);
  final modules = await dataService.getModules();
  return dataService.getUniqueBooks(modules);
}

@riverpod
Future<List<LearningModule>> dueModules(
  DueModulesRef ref,
  int daysThreshold,
) async {
  final dataService = ref.watch(learningDataServiceProvider);
  final modules = await dataService.getModules();
  final dueModules = <LearningModule>[];

  if (daysThreshold <= 0) {
    // Due today
    dueModules.addAll(dataService.getDueToday(modules));
  } else if (daysThreshold <= 7) {
    // Due this week
    dueModules.addAll(dataService.getDueThisWeek(modules));
  } else {
    // Due this month
    dueModules.addAll(dataService.getDueThisMonth(modules));
  }

  return dueModules;
}
