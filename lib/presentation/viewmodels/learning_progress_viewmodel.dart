// lib/presentation/viewmodels/learning_progress_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';

/// ViewModel for managing learning progress data and state
class LearningProgressViewModel extends ChangeNotifier {
  final LearningDataService _learningDataService;

  List<LearningModule> _modules = [];
  List<LearningModule> _filteredModules = [];
  String _selectedBook = 'All';
  DateTime? _selectedDate;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  List<LearningModule> get modules => _modules;
  List<LearningModule> get filteredModules => _filteredModules;
  String get selectedBook => _selectedBook;
  DateTime? get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  LearningProgressViewModel({required LearningDataService learningDataService})
    : _learningDataService = learningDataService;

  /// Initialize the ViewModel and load initial data
  Future<void> initialize() async {
    if (_isInitialized) return;
    await loadData();
    _isInitialized = true;
  }

  /// Load module data from service
  Future<void> loadData() async {
    setLoading(true);
    setErrorMessage(null);

    try {
      final modules = await _learningDataService.getModules();
      _modules = modules;
      _applyFiltersWithoutNotify(); // Use private method that doesn't notify
      setLoading(false); // This will trigger notification
    } catch (e) {
      handleLoadError(e.toString());
    }
  }

  /// Refresh data by clearing cache and reloading
  Future<void> refreshData() async {
    _learningDataService.resetCache();
    await loadData();
  }

  /// Apply book and date filters to the module list
  void applyFilters() {
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
      final bookMatch = _selectedBook == 'All' || module.book == _selectedBook;
      final dateMatch =
          _selectedDate == null ||
          (module.nextStudyDate != null &&
              AppDateUtils.isSameDay(module.nextStudyDate!, _selectedDate!));
      return bookMatch && dateMatch;
    }).toList();
  }

  /// Check if filtered modules list has changed
  bool _filteredModulesChanged(List<LearningModule> newModules) {
    if (_filteredModules.length != newModules.length) return true;
    return _filteredModules.asMap().entries.any(
      (entry) => entry.value.id != newModules[entry.key].id,
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
    setLoading(true);
    try {
      final success = await _learningDataService.exportData();
      setLoading(false);
      return success;
    } catch (e) {
      setErrorMessage('Error exporting data: $e');
      setLoading(false);
      return false;
    }
  }

  /// Get list of unique book names with "All" as first option
  List<String> getUniqueBooks() {
    if (_modules.isEmpty) return ['All'];
    final books =
        _modules.map((module) => module.book).toSet().toList()..sort();
    return ['All', ...books];
  }

  /// Handle load error by setting error message and disabling loading state
  void handleLoadError(String error) {
    setLoading(false);
    setErrorMessage('Error loading data: $error');
  }

  /// Set the loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set the error message
  void setErrorMessage(String? message) {
    _errorMessage = message;
    if (message != null) {
      // Only notify if there's an actual error
      notifyListeners();
    }
  }

  /// Get count of modules due within 7 days
  int getDueModulesCount() {
    return _filteredModules
        .where(
          (m) =>
              m.nextStudyDate != null &&
              m.nextStudyDate!.isBefore(
                DateTime.now().add(const Duration(days: 7)),
              ),
        )
        .length;
  }

  /// Get count of modules with 100% completion
  int getCompletedModulesCount() {
    return _filteredModules.where((m) => m.percentage == 100).length;
  }

  /// Get book stats for the selected book
  Future<Map<String, dynamic>> getBookStats() async {
    if (_selectedBook == 'All') return {};
    try {
      return await _learningDataService.getBookStats(_selectedBook);
    } catch (e) {
      setErrorMessage('Error loading book stats: $e');
      return {};
    }
  }

  /// Get dashboard stats with current filters
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final book = _selectedBook == 'All' ? null : _selectedBook;
      return await _learningDataService.getDashboardStats(
        book: book,
        date: _selectedDate,
      );
    } catch (e) {
      setErrorMessage('Error loading dashboard stats: $e');
      return {};
    }
  }
}
