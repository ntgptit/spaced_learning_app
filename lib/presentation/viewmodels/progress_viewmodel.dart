import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ProgressViewModel extends BaseViewModel {
  final ProgressRepository progressRepository;
  final EventBus eventBus;

  bool _isLoadingDueProgress = false;
  bool _isLoadingDetails = false;
  bool _isUpdating = false;

  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;

  ProgressViewModel({required this.progressRepository, required this.eventBus});

  bool get isLoadingDueProgress => _isLoadingDueProgress;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isUpdating => _isUpdating;

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

        if (progressList.isEmpty) {
          _selectedProgress = null;
          return null;
        }

        final progressDetail = await progressRepository.getProgressById(
          progressList[0].id,
        );
        _selectedProgress = progressDetail;
        return progressDetail;
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

      eventBus.fire(
        ProgressChangedEvent(userId: userId, hasDueTasks: result.isNotEmpty),
      );

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

        if (userId != null) {
          eventBus.fire(
            ProgressChangedEvent(userId: userId, hasDueTasks: true),
          );
        }

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

        final userData = await serviceLocator<StorageService>().getUserData();
        final userId = userData?['id'];
        if (userId != null) {
          eventBus.fire(
            TaskCompletedEvent(userId: userId.toString(), progressId: id),
          );
        }

        return progress;
      },
      errorPrefix: 'Failed to update progress',
    );
    _isUpdating = false;
    return result;
  }
}
