// lib/presentation/viewmodels/progress_viewmodel.dart
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
    beginLoading();
    notifyListeners(); // Notify that loading has started
    clearError();

    try {
      debugPrint('Loading progress details for id: $id');
      _selectedProgress = await progressRepository.getProgressById(id);
      debugPrint('Progress details loaded successfully');
    } catch (e) {
      handleError(e, prefix: 'Failed to load progress details');
      debugPrint('Error loading progress details: $e');
    } finally {
      _isLoadingDetails = false;
      endLoading();
      notifyListeners(); // Always notify at the end
    }
  }

  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Loading module progress for moduleId: $moduleId');
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
    } catch (e) {
      handleError(e, prefix: 'Failed to load module progress');
      debugPrint('Error loading module progress: $e');
      return null;
    } finally {
      endLoading();
      notifyListeners(); // Always notify at the end
    }
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
    notifyListeners(); // Notify that loading has started
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

      // Fire event to notify about task status using event_bus library
      eventBus.fire(
        ProgressChangedEvent(userId: userId, hasDueTasks: result.isNotEmpty),
      );

      updateLastUpdated();
    } catch (e) {
      handleError(e, prefix: 'Failed to load due progress');
      _progressRecords = []; // Clear old data if there's an error
      debugPrint('Error loading due progress: $e');
    } finally {
      _isLoadingDueProgress = false;
      endLoading();
      notifyListeners(); // Always notify at the end
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
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Creating progress for moduleId: $moduleId');
      final progress = await progressRepository.createProgress(
        moduleId: moduleId,
        userId: userId, // Pass optional userId
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );

      // Fire event for progress creation
      if (userId != null) {
        eventBus.fire(ProgressChangedEvent(userId: userId, hasDueTasks: true));
      }

      debugPrint('Progress created successfully: ${progress.id}');
      return progress;
    } catch (e) {
      handleError(e, prefix: 'Failed to create progress');
      debugPrint('Error creating progress: $e');
      return null;
    } finally {
      endLoading();
      notifyListeners(); // Always notify at the end
    }
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
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Updating progress with id: $id');
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

      // Fire event for task completion
      final userData = await serviceLocator<StorageService>().getUserData();
      final userId = userData?['id'];
      if (userId != null) {
        eventBus.fire(
          TaskCompletedEvent(userId: userId.toString(), progressId: id),
        );
      }

      debugPrint('Progress updated successfully');
      return progress;
    } catch (e) {
      handleError(e, prefix: 'Failed to update progress');
      debugPrint('Error updating progress: $e');
      return null;
    } finally {
      _isUpdating = false;
      endLoading();
      notifyListeners(); // Always notify at the end
    }
  }

  @override
  Future<T?> safeCall<T>({
    required Future<T> Function() action,
    String errorPrefix = 'Operation failed',
    bool handleLoading = true,
    bool updateTimestamp = true,
  }) async {
    if (handleLoading) beginLoading();
    clearError();
    notifyListeners(); // Notify at start

    try {
      final result = await action();
      if (updateTimestamp) updateLastUpdated();
      return result;
    } catch (e) {
      handleError(e, prefix: errorPrefix);
      return null;
    } finally {
      if (handleLoading) endLoading();
      notifyListeners(); // Always notify at the end
    }
  }
}
