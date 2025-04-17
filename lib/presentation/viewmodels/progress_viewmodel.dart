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

  // Thêm phương thức để xóa dữ liệu progress hiện tại
  void clearSelectedProgress() {
    _selectedProgress = null;
    notifyListeners();
  }

  String? _sanitizeId(String id) {
    // Hàm này kiểm tra và làm sạch ID
    if (id.isEmpty) {
      debugPrint('WARNING: Empty ID detected in ProgressViewModel');
      return null;
    }

    // Loại bỏ khoảng trắng dư thừa
    final sanitizedId = id.trim();

    if (sanitizedId != id) {
      debugPrint('ID sanitized from "$id" to "$sanitizedId"');
    }

    return sanitizedId;
  }

  Future<void> loadProgressDetails(String id) async {
    final sanitizedId = _sanitizeId(id);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return;
    }

    if (_isLoadingDetails) {
      debugPrint(
        'Already loading progress details, skipping duplicate request',
      );
      return;
    }

    _isLoadingDetails = true;
    beginLoading();
    notifyListeners(); // Notify that loading has started
    clearError();

    try {
      debugPrint('Loading progress details for id: $sanitizedId');
      _selectedProgress = await progressRepository.getProgressById(sanitizedId);

      if (_selectedProgress == null) {
        debugPrint('WARNING: Progress details loaded but result is null');
        setError('Failed to load progress: No data returned');
      } else {
        debugPrint(
          'Progress details loaded successfully for id: ${_selectedProgress!.id}',
        );

        // Verify ID consistency
        if (_selectedProgress!.id != sanitizedId) {
          debugPrint(
            'WARNING: ID mismatch between requested $sanitizedId and loaded ${_selectedProgress!.id}',
          );
        }
      }
    } catch (e) {
      handleError(e, prefix: 'Failed to load progress details');
      debugPrint('Error loading progress details: $e');
      _selectedProgress = null; // Clear data on error
    } finally {
      _isLoadingDetails = false;
      endLoading();
      notifyListeners(); // Always notify at the end
    }
  }

  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    final sanitizedId = _sanitizeId(moduleId);
    if (sanitizedId == null) {
      setError('Invalid module ID: Empty ID provided');
      notifyListeners();
      return null;
    }

    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Loading module progress for moduleId: $sanitizedId');
      final progressList = await progressRepository.getProgressByModuleId(
        sanitizedId,
        page: 0,
        size: 1, // Only get 1 progress
      );

      debugPrint('Progress list length: ${progressList.length}');

      if (progressList.isEmpty) {
        _selectedProgress = null;
        return null;
      }

      final progressId = progressList[0].id;
      debugPrint(
        'Found progress with ID: $progressId for module: $sanitizedId',
      );

      final progressDetail = await progressRepository.getProgressById(
        progressId,
      );
      _selectedProgress = progressDetail;

      debugPrint('Loaded progress details: ${_selectedProgress?.id}');
      return progressDetail;
    } catch (e) {
      handleError(e, prefix: 'Failed to load module progress');
      debugPrint('Error loading module progress: $e');
      _selectedProgress = null; // Clear data on error
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
    final sanitizedId = _sanitizeId(userId);
    if (sanitizedId == null) {
      setError('Invalid user ID: Empty ID provided');
      notifyListeners();
      return;
    }

    if (_isLoadingDueProgress) {
      debugPrint('Already loading due progress, skipping duplicate request');
      return;
    }

    _isLoadingDueProgress = true;
    beginLoading();
    notifyListeners(); // Notify that loading has started
    clearError();

    debugPrint(
      '[ProgressViewModel] Starting loadDueProgress for userId: $sanitizedId, date: $studyDate',
    );

    try {
      final List<ProgressSummary> result = await progressRepository
          .getDueProgress(
            sanitizedId,
            studyDate: studyDate,
            page: page,
            size: size,
          );

      debugPrint(
        '[ProgressViewModel] Received ${result.length} records from repository for due progress.',
      );

      // Log the first few progress IDs for debugging
      if (result.isNotEmpty) {
        final idList = result.take(3).map((p) => p.id).join(', ');
        debugPrint(
          'First few progress IDs: $idList${result.length > 3 ? '...' : ''}',
        );
      }

      _progressRecords = result;

      // Fire event to notify about task status using event_bus library
      eventBus.fire(
        ProgressChangedEvent(
          userId: sanitizedId,
          hasDueTasks: result.isNotEmpty,
        ),
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
    final sanitizedModuleId = _sanitizeId(moduleId);
    if (sanitizedModuleId == null) {
      setError('Invalid module ID: Empty ID provided');
      notifyListeners();
      return null;
    }

    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Creating progress for moduleId: $sanitizedModuleId');
      final progress = await progressRepository.createProgress(
        moduleId: sanitizedModuleId,
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
    final sanitizedId = _sanitizeId(id);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return null;
    }

    if (_isUpdating) {
      debugPrint('Already updating progress, skipping duplicate request');
      return null;
    }

    _isUpdating = true;
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Updating progress with id: $sanitizedId');
      final progress = await progressRepository.updateProgress(
        sanitizedId,
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );

      if (_selectedProgress?.id == sanitizedId) {
        _selectedProgress = progress;
      }

      // Fire event for task completion
      final userData = await serviceLocator<StorageService>().getUserData();
      final userId = userData?['id'];
      if (userId != null) {
        eventBus.fire(
          TaskCompletedEvent(
            userId: userId.toString(),
            progressId: sanitizedId,
          ),
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
