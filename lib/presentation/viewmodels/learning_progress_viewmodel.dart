// lib/presentation/viewmodels/learning_progress_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';

import '../../core/di/providers.dart';

part 'learning_progress_viewmodel.g.dart';

@riverpod
class LearningProgressState extends _$LearningProgressState {
  @override
  Future<List<LearningModule>> build() async {
    return loadData();
  }

  Future<List<LearningModule>> loadData() async {
    state = const AsyncValue.loading();
    try {
      debugPrint('LearningProgressViewModel: Loading module data');
      final modules = await ref.read(learningDataServiceProvider).getModules();
      state = AsyncValue.data(modules);
      debugPrint('LearningProgressViewModel: Loaded ${modules.length} modules');
      return modules;
    } catch (e) {
      debugPrint('Failed to load learning modules: $e');
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<void> refreshData() async {
    debugPrint(
      'LearningProgressViewModel: Refreshing data, explicitly resetting cache',
    );
    ref.read(learningDataServiceProvider).resetCache();
    await loadData();
  }

  Future<bool> exportData() async {
    try {
      return await ref.read(learningDataServiceProvider).exportData();
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getDashboardStats({
    String? book,
    DateTime? date,
  }) async {
    try {
      return await ref
          .read(learningDataServiceProvider)
          .getDashboardStats(book: book, date: date);
    } catch (e) {
      return {};
    }
  }

  List<String> getUniqueBooks() {
    final modules = state.valueOrNull ?? [];
    if (modules.isEmpty) return ['All'];

    final books = modules.map((module) => module.bookName).toSet().toList()
      ..sort();
    return ['All', ...books];
  }
}

@riverpod
class FilteredModules extends _$FilteredModules {
  @override
  List<LearningModule> build() {
    final modules = ref.watch(learningProgressStateProvider).valueOrNull ?? [];
    final selectedBook = ref.watch(selectedBookFilterProvider);
    final selectedDate = ref.watch(selectedDateFilterProvider);

    return _getFilteredModules(modules, selectedBook, selectedDate);
  }

  List<LearningModule> _getFilteredModules(
    List<LearningModule> modules,
    String selectedBook,
    DateTime? selectedDate,
  ) {
    return modules.where((module) {
      final bookMatch =
          selectedBook == 'All' || module.bookName == selectedBook;
      final dateMatch =
          selectedDate == null ||
          (module.progressNextStudyDate != null &&
              AppDateUtils.isSameDay(
                module.progressNextStudyDate!,
                selectedDate,
              ));
      return bookMatch && dateMatch;
    }).toList();
  }
}

@riverpod
class SelectedBookFilter extends _$SelectedBookFilter {
  @override
  String build() {
    return 'All';
  }

  void setSelectedBook(String book) {
    state = book;
  }
}

@riverpod
class SelectedDateFilter extends _$SelectedDateFilter {
  @override
  DateTime? build() {
    return null;
  }

  void setSelectedDate(DateTime? date) {
    state = date;
  }

  void clearDateFilter() {
    state = null;
  }
}

@riverpod
int dueModulesCount(Ref ref) {
  final filteredModules = ref.watch(filteredModulesProvider);
  return filteredModules
      .where(
        (m) =>
            m.progressNextStudyDate != null &&
            m.progressNextStudyDate!.isBefore(
              DateTime.now().add(const Duration(days: 7)),
            ),
      )
      .length;
}

@riverpod
int completedModulesCount(Ref ref) {
  final filteredModules = ref.watch(filteredModulesProvider);
  return filteredModules
      .where((m) => (m.progressLatestPercentComplete ?? 0) == 100)
      .length;
}
