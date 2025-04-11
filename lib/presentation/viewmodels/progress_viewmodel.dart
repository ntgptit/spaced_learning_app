// lib/presentation/viewmodels/progress_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// View model for module progress operations
class ProgressViewModel extends BaseViewModel {
  final ProgressRepository progressRepository;
  final ReminderManager? reminderManager;

  // Granular loading states for different operations
  bool _isLoadingDueProgress = false;
  bool _isLoadingDetails = false;
  bool _isUpdating = false;

  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;

  ProgressViewModel({
    required this.progressRepository,
    this.reminderManager, // Optional to avoid issues in unit tests
  });

  // Additional getters for specific loading states
  bool get isLoadingDueProgress => _isLoadingDueProgress;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isUpdating => _isUpdating;

  // Data getters
  List<ProgressSummary> get progressRecords => _progressRecords;
  ProgressDetail? get selectedProgress => _selectedProgress;

  /// Load all progress records with pagination
  // Future<void> loadProgressRecords({int page = 0, int size = 20}) async {
  //   if (isLoading) return; // Prevent duplicate calls

  //   await safeCall(
  //     action: () async {
  //       _progressRecords = await progressRepository.getAllProgress(
  //         page: page,
  //         size: size,
  //       );
  //       return _progressRecords;
  //     },
  //     errorPrefix: 'Failed to load progress records',
  //   );
  // }

  /// Load progress details by ID
  Future<void> loadProgressDetails(String id) async {
    if (_isLoadingDetails) return; // Prevent duplicate calls

    _isLoadingDetails = true;
    await safeCall(
      action: () async {
        _selectedProgress = await progressRepository.getProgressById(id);
        return _selectedProgress;
      },
      errorPrefix: 'Failed to load progress details',
    );
    _isLoadingDetails = false;
  }

  /// Load progress records by user ID
  // Future<void> loadProgressByUserId(
  //   String userId, {
  //   int page = 0,
  //   int size = 20,
  // }) async {
  //   await safeCall(
  //     action: () async {
  //       _progressRecords = await progressRepository.getProgressByUserId(
  //         userId,
  //         page: page,
  //         size: size,
  //       );
  //       return _progressRecords;
  //     },
  //     errorPrefix: 'Failed to load progress by user',
  //   );
  // }

  /// Load progress records by module ID
  // Future<void> loadProgressByModuleId(
  //   String moduleId, {
  //   int page = 0,
  //   int size = 20,
  // }) async {
  //   await safeCall(
  //     action: () async {
  //       _progressRecords = await progressRepository.getProgressByModuleId(
  //         moduleId,
  //         page: page,
  //         size: size,
  //       );
  //       return _progressRecords;
  //     },
  //     errorPrefix: 'Failed to load progress by module',
  //   );
  // }

  /// Load progress records by user ID and book ID
  // Future<void> loadProgressByUserAndBook(
  //   String userId,
  //   String bookId, {
  //   int page = 0,
  //   int size = 20,
  // }) async {
  //   await safeCall(
  //     action: () async {
  //       _progressRecords = await progressRepository.getProgressByUserAndBook(
  //         userId,
  //         bookId,
  //         page: page,
  //         size: size,
  //       );
  //       return _progressRecords;
  //     },
  //     errorPrefix: 'Failed to load progress by user and book',
  //   );
  // }

  /// Load progress by user ID and module ID
  // Future<ProgressDetail?> loadProgressByUserAndModule(
  //   String userId,
  //   String moduleId,
  // ) async {
  //   if (_isLoadingDetails) return null; // Prevent duplicate calls

  //   _isLoadingDetails = true;
  //   clearError();

  //   try {
  //     final progress = await progressRepository.getProgressByUserAndModule(
  //       userId,
  //       moduleId,
  //     );
  //     _selectedProgress = progress;
  //     return progress;
  //   } catch (e) {
  //     if (e.toString().contains('not found')) {
  //       // If not found, return null but don't set error (this is expected)
  //       _selectedProgress = null;
  //       return null;
  //     }
  //     handleError(e, prefix: 'Failed to load progress by user and module');
  //     return null;
  //   } finally {
  //     _isLoadingDetails = false;
  //     notifyListeners();
  //   }
  // }

  /// Load progress for a specific module
  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    return safeCall<ProgressDetail?>(
      action: () async {
        // Get progress list for this module
        final progressList = await progressRepository.getProgressByModuleId(
          moduleId,
          page: 0,
          size: 1, // Only get 1 progress
        );

        debugPrint('Progress list length: ${progressList.length}');

        // If there's any progress, get the first one
        if (progressList.isNotEmpty) {
          // Get progress details
          final progressDetail = await progressRepository.getProgressById(
            progressList[0].id,
          );
          _selectedProgress = progressDetail;
          return progressDetail;
        } else {
          _selectedProgress = null;
          return null;
        }
      },
      errorPrefix: 'Failed to load module progress',
    );
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
    beginLoading();
    clearError();

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

      updateLastUpdated();
    } catch (e) {
      handleError(e, prefix: 'Failed to load due progress');
      _progressRecords = []; // Clear old data if there's an error
    } finally {
      _isLoadingDueProgress = false;
      endLoading();
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
    return safeCall<ProgressDetail>(
      action: () async {
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
      },
      errorPrefix: 'Failed to create progress',
    );
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
    final result = await safeCall<ProgressDetail>(
      action: () async {
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
      },
      errorPrefix: 'Failed to update progress',
    );
    _isUpdating = false;
    return result;
  }

  /// Delete a progress record
  // Future<bool> deleteProgress(String id) async {
  //   final result = await safeCall<bool>(
  //     action: () async {
  //       await progressRepository.deleteProgress(id);

  //       if (_selectedProgress?.id == id) {
  //         _selectedProgress = null;
  //       }

  //       _progressRecords =
  //           _progressRecords.where((progress) => progress.id != id).toList();

  //       // Update reminders after deleting progress
  //       if (reminderManager != null) {
  //         await reminderManager!.scheduleAllReminders();
  //       }

  //       return true;
  //     },
  //     errorPrefix: 'Failed to delete progress',
  //   );
  //   return result ?? false;
  // }

  /// Refresh progress details
  // Future<void> refreshProgressDetails(String progressId) async {
  //   if (_isLoadingDetails) return; // Prevent duplicate calls

  //   _isLoadingDetails = true;
  //   notifyListeners();

  //   try {
  //     _selectedProgress = await progressRepository.getProgressById(progressId);
  //     // lib/presentation/viewmodels/progress_viewmodel.dart (tiếp theo)
  //   } catch (e) {
  //     // Just log the error, don't set error message to avoid UI disruption
  //     debugPrint('Error refreshing progress details: $e');
  //   } finally {
  //     _isLoadingDetails = false;
  //     notifyListeners();
  //   }
  // }

  /// Get the count of due progress records
  // int getDueTodayCount() {
  //   try {
  //     return _progressRecords.length;
  //   } catch (e) {
  //     debugPrint('Error getting due progress count: $e');
  //     return 0;
  //   }
  // }
}
