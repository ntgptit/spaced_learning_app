import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// View model for module progress operations
class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository progressRepository;
  final ReminderManager? reminderManager;

  // Granular loading states for different operations
  bool _isLoadingAllProgress = false;
  bool _isLoadingDueProgress = false;
  bool _isLoadingDetails = false;
  bool _isLoadingByUser = false;
  bool _isLoadingByModule = false;
  bool _isLoadingByBook = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;
  String? _errorMessage;

  ProgressViewModel({
    required this.progressRepository,
    this.reminderManager, // Optional to avoid issues in unit tests
  });

  // Getters for loading states
  bool get isLoading =>
      _isLoadingAllProgress ||
      _isLoadingDueProgress ||
      _isLoadingDetails ||
      _isLoadingByUser ||
      _isLoadingByModule ||
      _isLoadingByBook ||
      _isCreating ||
      _isUpdating ||
      _isDeleting;

  bool get isLoadingDueProgress => _isLoadingDueProgress;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isUpdating => _isUpdating;

  // Getters for data
  List<ProgressSummary> get progressRecords => _progressRecords;
  ProgressDetail? get selectedProgress => _selectedProgress;
  String? get errorMessage => _errorMessage;

  /// Load all progress records with pagination
  Future<void> loadProgressRecords({int page = 0, int size = 20}) async {
    if (_isLoadingAllProgress) return; // Prevent duplicate calls

    _isLoadingAllProgress = true;
    _errorMessage = null;
    notifyListeners();

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
      _isLoadingAllProgress = false;
      notifyListeners();
    }
  }

  /// Load progress details by ID
  Future<void> loadProgressDetails(String id) async {
    if (_isLoadingDetails) return; // Prevent duplicate calls

    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProgress = await progressRepository.getProgressById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Load progress records by user ID
  Future<void> loadProgressByUserId(
    String userId, {
    int page = 0,
    int size = 20,
  }) async {
    if (_isLoadingByUser) return; // Prevent duplicate calls

    _isLoadingByUser = true;
    _errorMessage = null;
    notifyListeners();

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
      _isLoadingByUser = false;
      notifyListeners();
    }
  }

  /// Load progress records by module ID
  Future<void> loadProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  }) async {
    if (_isLoadingByModule) return; // Prevent duplicate calls

    _isLoadingByModule = true;
    _errorMessage = null;
    notifyListeners();

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
      _isLoadingByModule = false;
      notifyListeners();
    }
  }

  /// Load progress records by user ID and book ID
  Future<void> loadProgressByUserAndBook(
    String userId,
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    if (_isLoadingByBook) return; // Prevent duplicate calls

    _isLoadingByBook = true;
    _errorMessage = null;
    notifyListeners();

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
      _isLoadingByBook = false;
      notifyListeners();
    }
  }

  /// Load progress by user ID and module ID
  Future<ProgressDetail?> loadProgressByUserAndModule(
    String userId,
    String moduleId,
  ) async {
    if (_isLoadingDetails) return null; // Prevent duplicate calls

    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();

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
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Load progress for a specific module
  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    if (_isLoadingByModule) return null; // Prevent duplicate calls

    _isLoadingByModule = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get progress list for this module
      final progressList = await progressRepository.getProgressByModuleId(
        moduleId,
        page: 0,
        size: 1, // Only get 1 progress
      );

      debugPrint('Progress list length: ${progressList.length}');
      debugPrint('Progress list content: $progressList');

      // If there's any progress, get the first one
      if (progressList.isNotEmpty) {
        // Get progress details
        final progressDetail = await progressRepository.getProgressById(
          progressList[0].id,
        );
        _selectedProgress = progressDetail;
        debugPrint('Progress found for module: YES');
        return progressDetail;
      } else {
        debugPrint('Progress not found for module');
        _selectedProgress = null;
        return null;
      }
    } on AppException catch (e) {
      _errorMessage = e.message;
      _selectedProgress = null;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _selectedProgress = null;
      return null;
    } finally {
      _isLoadingByModule = false;
      notifyListeners();
    }
  }

  /// Load progress records due for study with improved state management
  Future<void> loadDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    if (_isLoadingDueProgress) return; // Prevent duplicate calls

    _isLoadingDueProgress = true;
    _errorMessage = null;
    notifyListeners();

    // DEBUG: Log start of loading
    debugPrint(
      '[ProgressViewModel] Starting loadDueProgress for userId: $userId, date: $studyDate',
    );

    try {
      // Get data from repository
      final List<ProgressSummary> result = await progressRepository
          .getDueProgress(userId, studyDate: studyDate, page: page, size: size);

      // DEBUG: Log repository results
      debugPrint(
        '[ProgressViewModel] Received ${result.length} records from repository for due progress.',
      );

      // Assign data to state
      _progressRecords = result;

      // Update reminders after loading data
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

      // DEBUG: Log after state assignment
      debugPrint(
        '[ProgressViewModel] Assigned ${result.length} records to _progressRecords.',
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
      _progressRecords = []; // Clear old data if there's an error

      // DEBUG: Log AppException error
      debugPrint(
        '[ProgressViewModel] AppException during loadDueProgress: $_errorMessage',
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _progressRecords = []; // Clear old data if there's an error

      // DEBUG: Log other errors
      debugPrint(
        '[ProgressViewModel] Unexpected error during loadDueProgress: $e',
      );
    } finally {
      _isLoadingDueProgress = false;
      notifyListeners();

      // DEBUG: Log end of loading (success or failure)
      debugPrint(
        '[ProgressViewModel] Finished loadDueProgress. isLoading: $_isLoadingDueProgress, error: $_errorMessage, record count: ${_progressRecords.length}',
      );
    }
  }

  /// Create a new progress record
  Future<ProgressDetail?> createProgress({
    required String moduleId,
    String? userId, // Optional userId
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    if (_isCreating) return null; // Prevent duplicate calls

    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final progress = await progressRepository.createProgress(
        moduleId: moduleId,
        userId: userId, // Pass optional userId
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );

      // Update reminders after creating new progress
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _isCreating = false;
      notifyListeners();
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
    if (_isUpdating) return null; // Prevent duplicate calls

    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

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

      // Update reminders after completing a task
      if (reminderManager != null) {
        await reminderManager!.updateRemindersAfterTaskCompletion();
      }

      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  /// Delete a progress record
  Future<bool> deleteProgress(String id) async {
    if (_isDeleting) return false; // Prevent duplicate calls

    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await progressRepository.deleteProgress(id);

      if (_selectedProgress?.id == id) {
        _selectedProgress = null;
      }

      _progressRecords =
          _progressRecords.where((progress) => progress.id != id).toList();

      // Update reminders after deleting progress
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  /// Refresh progress details
  Future<void> refreshProgressDetails(String progressId) async {
    if (_isLoadingDetails) return; // Prevent duplicate calls

    _isLoadingDetails = true;
    notifyListeners();

    try {
      _selectedProgress = await progressRepository.getProgressById(progressId);
    } catch (e) {
      // Just log the error, don't set error message to avoid UI disruption
      debugPrint('Error refreshing progress details: $e');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Get the count of due progress records
  Future<int> getDueTodayCount() async {
    try {
      return _progressRecords.length;
    } catch (e) {
      debugPrint('Error getting due progress count: $e');
      return 0;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
