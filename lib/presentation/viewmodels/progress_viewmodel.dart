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

  void clearSelectedProgress() {
    _selectedProgress = null;
    notifyListeners();
  }

  /// Validates and sanitizes ID inputs
  String? _sanitizeId(String id) {
    if (id.isEmpty) {
      debugPrint('WARNING: Empty ID detected in ProgressViewModel');
      return null;
    }

    final sanitizedId = id.trim();
    if (sanitizedId != id) {
      debugPrint('ID sanitized from "$id" to "$sanitizedId"');
    }
    return sanitizedId;
  }

  /// Loads progress details by ID
  Future<void> loadProgressDetails(
    String id, {
    bool notifyAtStart = false,
  }) async {
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
    if (notifyAtStart) {
      beginLoading();
    }

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
        clearError();
      }
    } catch (e) {
      handleError(e, prefix: 'Failed to load progress details');
      _selectedProgress = null;
    } finally {
      _isLoadingDetails = false;
      endLoading();
    }
  }

  /// Loads module progress by module ID
  Future<ProgressDetail?> loadModuleProgress(String moduleId) async {
    final sanitizedId = _sanitizeId(moduleId);
    if (sanitizedId == null) {
      setError('Invalid module ID: Empty ID provided');
      notifyListeners();
      return null;
    }

    return safeCall<ProgressDetail?>(
      action: () async {
        debugPrint('Loading module progress for moduleId: $sanitizedId');
        final progressList = await progressRepository.getProgressByModuleId(
          sanitizedId,
          page: 0,
          size: 1,
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
      },
      errorPrefix: 'Failed to load module progress',
    );
  }

  /// Loads due progress for a user
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
    notifyListeners();
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

      if (result.isNotEmpty) {
        final idList = result.take(3).map((p) => p.id).join(', ');
        debugPrint(
          'First few progress IDs: $idList${result.length > 3 ? '...' : ''}',
        );
      }

      _progressRecords = result;

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
    }
  }

  /// Creates new progress
  Future<ProgressDetail?> createProgress({
    required String moduleId,
    String? userId,
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

    return safeCall<ProgressDetail?>(
      action: () async {
        debugPrint('Creating progress for moduleId: $sanitizedModuleId');
        final progress = await progressRepository.createProgress(
          moduleId: sanitizedModuleId,
          userId: userId,
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

        debugPrint('Progress created successfully: ${progress.id}');
        return progress;
      },
      errorPrefix: 'Failed to create progress',
    );
  }

  /// Updates existing progress
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
    }
  }
}
