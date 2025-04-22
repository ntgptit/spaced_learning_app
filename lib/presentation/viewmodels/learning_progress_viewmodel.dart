import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class LearningProgressViewModel extends BaseViewModel {
  final LearningDataService _learningDataService;

  List<LearningModule> _modules = [];
  List<LearningModule> _filteredModules = [];
  String _selectedBook = 'All';
  DateTime? _selectedDate;

  List<LearningModule> get modules => _modules;

  List<LearningModule> get filteredModules => _filteredModules;

  String get selectedBook => _selectedBook;

  DateTime? get selectedDate => _selectedDate;

  LearningProgressViewModel({required LearningDataService learningDataService})
    : _learningDataService = learningDataService;

  /// Initialize the view model
  Future<void> initialize() async {
    if (isInitialized && lastUpdated != null) {
      if (!shouldRefresh()) {
        return;
      }
    }

    if (isRefreshing) return;

    await loadData();
    setInitialized(true);
  }

  /// Load module data from service
  Future<void> loadData() async {
    await safeCall(
      action: () async {
        debugPrint('LearningProgressViewModel: Loading module data');
        final modules = await _learningDataService.getModules();
        _modules = modules;
        _applyFiltersWithoutNotify();
        setInitialized(true);

        debugPrint(
          'LearningProgressViewModel: Loaded ${modules.length} modules',
        );
        return modules;
      },
      errorPrefix: 'Failed to load learning modules',
      updateTimestamp: true,
    );
  }

  /// Refresh data by resetting cache and reloading
  Future<void> refreshData() async {
    debugPrint(
      'LearningProgressViewModel: Refreshing data, explicitly resetting cache',
    );

    _learningDataService.resetCache();
    await loadData();
  }

  /// Apply filters to modules and notify listeners
  void applyFilters() {
    if (isRefreshing) return;

    final newFilteredModules = _getFilteredModules();
    if (_filteredModulesChanged(newFilteredModules)) {
      _filteredModules = newFilteredModules;
      notifyListeners();
    }
  }

  /// Apply filters without notifying listeners
  void _applyFiltersWithoutNotify() {
    _filteredModules = _getFilteredModules();
  }

  /// Get filtered modules based on selected filters
  List<LearningModule> _getFilteredModules() {
    return _modules.where((module) {
      final bookMatch =
          _selectedBook == 'All' || module.bookName == _selectedBook;
      final dateMatch =
          _selectedDate == null ||
          (module.progressNextStudyDate != null &&
              AppDateUtils.isSameDay(
                module.progressNextStudyDate!,
                _selectedDate!,
              ));
      return bookMatch && dateMatch;
    }).toList();
  }

  /// Check if filtered modules have changed
  bool _filteredModulesChanged(List<LearningModule> newModules) {
    if (_filteredModules.length != newModules.length) return true;

    return _filteredModules.asMap().entries.any(
      (entry) =>
          entry.value.moduleNo != newModules[entry.key].moduleNo ||
          entry.value.bookNo != newModules[entry.key].bookNo,
    );
  }

  /// Set selected book filter
  void setSelectedBook(String book) {
    if (_selectedBook != book) {
      _selectedBook = book;
      applyFilters();
    }
  }

  /// Set selected date filter
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    applyFilters();
  }

  /// Clear date filter
  void clearDateFilter() {
    if (_selectedDate != null) {
      _selectedDate = null;
      applyFilters();
    }
  }

  /// Export learning data
  Future<bool> exportData() async {
    final result = await safeCall<bool>(
      action: () => _learningDataService.exportData(),
      errorPrefix: 'Failed to export data',
    );
    return result ?? false;
  }

  /// Get unique book names for filter dropdown
  List<String> getUniqueBooks() {
    if (_modules.isEmpty) return ['All'];

    final books = _modules.map((module) => module.bookName).toSet().toList()
      ..sort();
    return ['All', ...books];
  }

  /// Get count of due modules
  int getDueModulesCount() {
    return _filteredModules
        .where(
          (m) =>
              m.progressNextStudyDate != null &&
              m.progressNextStudyDate!.isBefore(
                DateTime.now().add(const Duration(days: 7)),
              ),
        )
        .length;
  }

  /// Get count of completed modules
  int getCompletedModulesCount() {
    return _filteredModules
        .where((m) => (m.progressLatestPercentComplete ?? 0) == 100)
        .length;
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final result = await safeCall<Map<String, dynamic>>(
      action: () {
        final book = _selectedBook == 'All' ? null : _selectedBook;
        return _learningDataService.getDashboardStats(
          book: book,
          date: _selectedDate,
        );
      },
      errorPrefix: 'Failed to load dashboard statistics',
      handleLoading: false,
    );
    return result ?? {};
  }
}
