import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class RepetitionViewModel extends BaseViewModel {
  final RepetitionRepository repetitionRepository;
  List<Repetition> _repetitions = [];
  Repetition? _selectedRepetition;
  bool _isLoading = false;

  RepetitionViewModel({required this.repetitionRepository});

  List<Repetition> get repetitions => _repetitions;

  Repetition? get selectedRepetition => _selectedRepetition;

  /// Clears stored repetitions and selected repetition state
  void clearRepetitions() {
    _repetitions = [];
    _selectedRepetition = null;
    notifyListeners();
  }

  /// Validates and sanitizes ID inputs
  String? _sanitizeId(String id) {
    if (id.isEmpty) {
      debugPrint('WARNING: Empty ID detected in RepetitionViewModel');
      return null;
    }

    final sanitizedId = id.trim();
    if (sanitizedId != id) {
      debugPrint('ID sanitized from "$id" to "$sanitizedId"');
    }
    return sanitizedId;
  }

  /// Loads repetitions by progress ID
  Future<void> loadRepetitionsByProgressId(
    String progressId, {
    bool notifyAtStart = false,
  }) async {
    final sanitizedId = _sanitizeId(progressId);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return;
    }

    if (_isLoading) {
      debugPrint('Already loading repetitions, skipping duplicate request');
      return;
    }

    _isLoading = true;
    if (notifyAtStart) {
      beginLoading();
    }
    clearError();

    try {
      debugPrint('Loading repetitions for progressId: $sanitizedId');
      _repetitions = await repetitionRepository.getRepetitionsByProgressId(
        sanitizedId,
      );
      debugPrint('Loaded ${_repetitions.length} repetitions');

      if (_repetitions.isNotEmpty) {
        for (int i = 0; i < min(_repetitions.length, 3); i++) {
          final rep = _repetitions[i];
          debugPrint(
            'Repetition $i: ID=${rep.id}, Order=${rep.repetitionOrder}, Status=${rep.status}',
          );
        }
      }
    } catch (e) {
      handleError(e, prefix: 'Failed to load repetitions by progress');
      _repetitions = []; // Clear data on error
    } finally {
      _isLoading = false;
      endLoading();
    }
  }

  /// Creates default repetition schedule
  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    final sanitizedId = _sanitizeId(moduleProgressId);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return [];
    }

    return await safeCall<List<Repetition>>(
          action: () async {
            debugPrint(
              'Creating default schedule for progressId: $sanitizedId',
            );
            final schedule = await repetitionRepository.createDefaultSchedule(
              sanitizedId,
            );
            debugPrint('Created schedule with ${schedule.length} repetitions');
            return schedule;
          },
          errorPrefix: 'Failed to create repetition schedule',
          handleLoading: true,
        ) ??
        [];
  }

  /// Updates repetition status, date and completion
  Future<Repetition?> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
    double? percentComplete,
  }) async {
    final sanitizedId = _sanitizeId(id);
    if (sanitizedId == null) {
      setError('Invalid repetition ID: Empty ID provided');
      notifyListeners();
      return null;
    }

    return safeCall<Repetition?>(
      action: () async {
        debugPrint('Updating repetition: $sanitizedId');
        debugPrint(
          'Status: $status, ReviewDate: $reviewDate, RescheduleFollowing: $rescheduleFollowing',
        );

        final repetition = await repetitionRepository.updateRepetition(
          sanitizedId,
          status: status,
          reviewDate: reviewDate,
          rescheduleFollowing: rescheduleFollowing,
          percentComplete: percentComplete,
        );

        if (_selectedRepetition?.id == sanitizedId) {
          _selectedRepetition = repetition;
        }

        final index = _repetitions.indexWhere((r) => r.id == sanitizedId);
        if (index >= 0) {
          _repetitions[index] = repetition;
        }

        if (rescheduleFollowing) {
          await loadRepetitionsByProgressId(repetition.moduleProgressId);
        }

        debugPrint('Repetition updated successfully');
        return repetition;
      },
      errorPrefix: 'Failed to update repetition',
    );
  }

  /// Checks if all repetitions for a progress are completed
  Future<bool> areAllRepetitionsCompleted(String progressId) async {
    final sanitizedId = _sanitizeId(progressId);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return false;
    }

    try {
      debugPrint('Checking completion status for progressId: $sanitizedId');

      List<Repetition> repetitionsToCheck;
      final bool currentDataValid =
          _repetitions.isNotEmpty &&
          _repetitions.first.moduleProgressId == sanitizedId;

      if (!currentDataValid) {
        debugPrint(
          'No cached repetitions for progressId: $sanitizedId, loading from repository',
        );
        repetitionsToCheck = await repetitionRepository
            .getRepetitionsByProgressId(sanitizedId);
      } else {
        repetitionsToCheck = _repetitions;
      }

      if (repetitionsToCheck.isEmpty) {
        debugPrint('No repetitions found for this progress');
        return false;
      }

      final totalCount = repetitionsToCheck.length;
      final completedCount = repetitionsToCheck
          .where((r) => r.status == RepetitionStatus.completed)
          .length;

      final isCompleted = completedCount >= totalCount;
      debugPrint(
        'Completion check: $completedCount/$totalCount completed. All completed: $isCompleted',
      );
      return isCompleted;
    } catch (e) {
      handleError(e, prefix: 'Failed to check repetition completion status');
      debugPrint('Error checking completion status: $e');
      return false;
    }
  }

  /// Get cycle information text based on cycle studied
  String getCycleInfo(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'You are in the first learning cycle. Complete 5 review sessions to move to the next cycle.';
      case CycleStudied.firstReview:
        return 'You are in the first review cycle. Complete all 5 review sessions to proceed.';
      case CycleStudied.secondReview:
        return 'You are in the second review cycle. You\'re doing great!';
      case CycleStudied.thirdReview:
        return 'You are in the third review cycle. You almost have this mastered!';
      case CycleStudied.moreThanThreeReviews:
        return 'You\'ve completed more than 3 review cycles. The knowledge is well reinforced!';
    }
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
}
