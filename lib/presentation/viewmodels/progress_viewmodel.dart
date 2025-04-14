// lib/presentation/viewmodels/progress_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ProgressViewModel extends BaseViewModel {
  final ProgressRepository progressRepository;
  final ReminderManager? reminderManager;

  bool _isLoadingDueProgress = false;
  bool _isLoadingDetails = false;
  bool _isUpdating = false;
  bool _isSchedulingReminders = false;

  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;

  ProgressViewModel({
    required this.progressRepository,
    this.reminderManager, // Optional to avoid issues in unit tests
  });

  bool get isLoadingDueProgress => _isLoadingDueProgress;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isUpdating => _isUpdating;
  bool get isSchedulingReminders => _isSchedulingReminders;

  List<ProgressSummary> get progressRecords => _progressRecords;
  ProgressDetail? get selectedProgress => _selectedProgress;

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

  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    return safeCall<ProgressDetail?>(
      action: () async {
        final progressList = await progressRepository.getProgressByModuleId(
          moduleId,
          page: 0,
          size: 1, // Only get 1 progress
        );

        debugPrint('Progress list length: ${progressList.length}');

        if (progressList.isNotEmpty) {
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

    debugPrint(
      '[ProgressViewModel] Starting loadDueProgress for userId: $userId, date: $studyDate',
    );

    try {
      final List<ProgressSummary> result = await progressRepository
          .getDueProgress(userId, studyDate: studyDate, page: page, size: size);

      debugPrint(
        '[ProgressViewModel] Received ${result.length} records from repository for due progress.',
      );

      _progressRecords = result;

      // Safely schedule reminders after loading progress
      await _scheduleReminders();

      updateLastUpdated();
    } catch (e) {
      handleError(e, prefix: 'Failed to load due progress');
      _progressRecords = []; // Clear old data if there's an error
    } finally {
      _isLoadingDueProgress = false;
      endLoading();
    }
  }

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

        // Safely schedule reminders after creating progress
        await _scheduleReminders();

        return progress;
      },
      errorPrefix: 'Failed to create progress',
    );
  }

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

        // Safely update reminders after task completion
        await _updateRemindersAfterTaskCompletion();

        return progress;
      },
      errorPrefix: 'Failed to update progress',
    );
    _isUpdating = false;
    return result;
  }

  // Safely handle reminder scheduling
  Future<bool> _scheduleReminders() async {
    if (reminderManager == null) return false;
    if (_isSchedulingReminders) return false;

    _isSchedulingReminders = true;
    try {
      final result = await reminderManager!.scheduleAllReminders();
      debugPrint('[ProgressViewModel] Reminders scheduled: $result');
      return result;
    } catch (e) {
      debugPrint('[ProgressViewModel] Error scheduling reminders: $e');
      return false;
    } finally {
      _isSchedulingReminders = false;
    }
  }

  // Safely handle reminder updates after task completion
  Future<bool> _updateRemindersAfterTaskCompletion() async {
    if (reminderManager == null) return false;
    if (_isSchedulingReminders) return false;

    _isSchedulingReminders = true;
    try {
      final result =
          await reminderManager!.updateRemindersAfterTaskCompletion();
      debugPrint(
        '[ProgressViewModel] Reminders updated after task completion: $result',
      );
      return result;
    } catch (e) {
      debugPrint(
        '[ProgressViewModel] Error updating reminders after task completion: $e',
      );
      return false;
    } finally {
      _isSchedulingReminders = false;
    }
  }

  // Force manual refresh of reminders, exposed to UI
  Future<bool> refreshReminders() async {
    return _scheduleReminders();
  }
}
