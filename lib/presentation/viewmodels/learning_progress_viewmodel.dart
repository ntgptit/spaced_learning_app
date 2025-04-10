// lib/presentation/viewmodels/learning_progress_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// ViewModel for managing learning progress data and state
class LearningProgressViewModel extends BaseViewModel {
  final LearningDataService _learningDataService;

  List<LearningModule> _modules = [];
  List<LearningModule> _filteredModules = [];
  String _selectedBook = 'All';
  DateTime? _selectedDate;

  // Getters
  List<LearningModule> get modules => _modules;
  List<LearningModule> get filteredModules => _filteredModules;
  String get selectedBook => _selectedBook;
  DateTime? get selectedDate => _selectedDate;

  LearningProgressViewModel({required LearningDataService learningDataService})
    : _learningDataService = learningDataService;

  /// Initialize the ViewModel and load initial data
  Future<void> initialize() async {
    // If already initialized and recently updated, skip loading
    if (isInitialized && lastUpdated != null) {
      if (!shouldRefresh()) {
        // Data is recent, no need to refresh
        return;
      }
    }

    // If already refreshing, don't start another refresh
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

  /// Refresh data by clearing cache and reloading
  Future<void> refreshData() async {
    debugPrint(
      'LearningProgressViewModel: Refreshing data, explicitly resetting cache',
    );

    // Always clear the cache
    _learningDataService.resetCache();

    // Load fresh data
    await loadData();
  }

  /// Apply book and date filters to the module list
  void applyFilters() {
    // Don't apply filters if refreshing
    if (isRefreshing) return;

    final newFilteredModules = _getFilteredModules();

    if (_filteredModulesChanged(newFilteredModules)) {
      _filteredModules = newFilteredModules;
      notifyListeners();
    }
  }

  /// Apply filters without triggering notification
  void _applyFiltersWithoutNotify() {
    _filteredModules = _getFilteredModules();
  }

  /// Get filtered modules based on current filters
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

  /// Check if filtered modules list has changed
  bool _filteredModulesChanged(List<LearningModule> newModules) {
    if (_filteredModules.length != newModules.length) return true;

    // Use moduleNo instead of id
    return _filteredModules.asMap().entries.any(
      (entry) =>
          entry.value.moduleNo != newModules[entry.key].moduleNo ||
          entry.value.bookNo != newModules[entry.key].bookNo,
    );
  }

  /// Set the selected book filter
  void setSelectedBook(String book) {
    if (_selectedBook != book) {
      _selectedBook = book;
      applyFilters();
    }
  }

  /// Set the selected date filter
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    applyFilters();
  }

  /// Clear the date filter
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

  /// Get list of unique book names with "All" as first option
  List<String> getUniqueBooks() {
    if (_modules.isEmpty) return ['All'];
    final books =
        _modules.map((module) => module.bookName).toSet().toList()..sort();
    return ['All', ...books];
  }

  /// Get count of modules due within 7 days
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

  /// Get count of modules with 100% completion
  int getCompletedModulesCount() {
    return _filteredModules
        .where((m) => (m.progressLatestPercentComplete ?? 0) == 100)
        .length;
  }

  /// Get book stats for the selected book
  Future<Map<String, dynamic>> getBookStats() async {
    if (_selectedBook == 'All') return {};

    final result = await safeCall<Map<String, dynamic>>(
      action: () => _learningDataService.getBookStats(_selectedBook),
      errorPrefix: 'Failed to load book statistics',
      handleLoading: false,
    );
    return result ?? {};
  }

  /// Get dashboard stats with current filters
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
