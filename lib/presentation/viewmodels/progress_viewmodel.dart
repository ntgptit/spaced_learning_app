import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// View model for module progress operations
class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository progressRepository;

  bool _isLoading = false;
  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;
  String? _errorMessage;

  ProgressViewModel({required this.progressRepository});

  // Getters
  bool get isLoading => _isLoading;
  List<ProgressSummary> get progressRecords => _progressRecords;
  ProgressDetail? get selectedProgress => _selectedProgress;
  String? get errorMessage => _errorMessage;

  /// Load all progress records with pagination
  Future<void> loadProgressRecords({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getAllProgress(
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress details by ID
  Future<void> loadProgressDetails(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedProgress = await progressRepository.getProgressById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records by user ID
  Future<void> loadProgressByUserId(
    String userId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByUserId(
        userId,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records by module ID
  Future<void> loadProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByModuleId(
        moduleId,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records by user ID and book ID
  Future<void> loadProgressByUserAndBook(
    String userId,
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByUserAndBook(
        userId,
        bookId,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress by user ID and module ID
  Future<ProgressDetail?> loadProgressByUserAndModule(
    String userId,
    String moduleId,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.getProgressByUserAndModule(
        userId,
        moduleId,
      );
      _selectedProgress = progress;
      return progress;
    } on NotFoundException {
      // If not found, return null but don't set error (this is expected)
      _selectedProgress = null;
      return null;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _selectedProgress = null;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _selectedProgress = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress for current user and a specific module
  Future<ProgressDetail?> loadCurrentUserProgressByModule(
    String moduleId,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.getCurrentUserProgressByModule(
        moduleId,
      );
      _selectedProgress = progress;
      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _selectedProgress = null;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _selectedProgress = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records due for study
  Future<void> loadDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getDueProgress(
        userId,
        studyDate: studyDate,
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new progress record
  Future<ProgressDetail?> createProgress({
    required String moduleId,
    required String userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.createProgress(
        moduleId: moduleId,
        userId: userId,
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );
      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update a progress record
  Future<ProgressDetail?> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.updateProgress(
        id,
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );

      if (_selectedProgress?.id == id) {
        _selectedProgress = progress;
      }

      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a progress record
  Future<bool> deleteProgress(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await progressRepository.deleteProgress(id);

      if (_selectedProgress?.id == id) {
        _selectedProgress = null;
      }

      _progressRecords =
          _progressRecords.where((progress) => progress.id != id).toList();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh progress details
  Future<void> refreshProgressDetails(String progressId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedProgress = await progressRepository.getProgressById(progressId);
    } catch (e) {
      // Just log the error, don't set error message to avoid UI disruption
      debugPrint('Error refreshing progress details: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
