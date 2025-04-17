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

  // Thêm phương thức để xóa dữ liệu repetitions hiện tại
  void clearRepetitions() {
    _repetitions = [];
    _selectedRepetition = null;
    notifyListeners();
  }

  String? _sanitizeId(String id) {
    // Hàm này kiểm tra và làm sạch ID
    if (id.isEmpty) {
      debugPrint('WARNING: Empty ID detected in RepetitionViewModel');
      return null;
    }

    // Loại bỏ khoảng trắng dư thừa
    final sanitizedId = id.trim();

    if (sanitizedId != id) {
      debugPrint('ID sanitized from "$id" to "$sanitizedId"');
    }

    return sanitizedId;
  }

  Future<void> loadRepetitionsByProgressId(String progressId) async {
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
    beginLoading();
    notifyListeners(); // Notify loading started
    clearError();

    try {
      debugPrint('Loading repetitions for progressId: $sanitizedId');
      _repetitions = await repetitionRepository.getRepetitionsByProgressId(
        sanitizedId,
      );
      debugPrint('Loaded ${_repetitions.length} repetitions');

      // Log some details about the first few repetitions
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
      debugPrint('Error loading repetitions: $e');
      _repetitions = []; // Clear data on error
    } finally {
      _isLoading = false;
      endLoading();
      notifyListeners(); // Always notify at end
    }
  }

  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    final sanitizedId = _sanitizeId(moduleProgressId);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return [];
    }

    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Creating default schedule for progressId: $sanitizedId');
      final schedule = await repetitionRepository.createDefaultSchedule(
        sanitizedId,
      );
      debugPrint('Created schedule with ${schedule.length} repetitions');
      return schedule;
    } catch (e) {
      handleError(e, prefix: 'Failed to create repetition schedule');
      debugPrint('Error creating schedule: $e');
      return [];
    } finally {
      endLoading();
      notifyListeners();
    }
  }

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

    beginLoading();
    notifyListeners();
    clearError();

    try {
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

      // Update the list if this repetition is in it
      final index = _repetitions.indexWhere((r) => r.id == sanitizedId);
      if (index >= 0) {
        _repetitions[index] = repetition;
      }

      // If we need to reschedule following repetitions, reload everything
      if (rescheduleFollowing) {
        await loadRepetitionsByProgressId(repetition.moduleProgressId);
      }

      debugPrint('Repetition updated successfully');
      return repetition;
    } catch (e) {
      handleError(e, prefix: 'Failed to update repetition');
      debugPrint('Error updating repetition: $e');
      return null;
    } finally {
      endLoading();
      notifyListeners();
    }
  }

  Future<bool> areAllRepetitionsCompleted(String progressId) async {
    final sanitizedId = _sanitizeId(progressId);
    if (sanitizedId == null) {
      setError('Invalid progress ID: Empty ID provided');
      notifyListeners();
      return false;
    }

    try {
      debugPrint('Checking completion status for progressId: $sanitizedId');

      // If we already have loaded repetitions for this progress, use them
      List<Repetition> repetitionsToCheck;

      // Check if our current repetitions belong to the requested progress ID
      final bool currentDataValid =
          _repetitions.isNotEmpty &&
          _repetitions.first.moduleProgressId == sanitizedId;

      // Otherwise, load them from repository
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
      final completedCount =
          repetitionsToCheck
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

  String getCycleInfo(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'You are in the first learning cycle. Complete 5 review sessions to move to the next cycle.';
      case CycleStudied.firstReview:
        return 'You are in the first review cycle. Complete all 5 review sessions to proceed.';
      case CycleStudied.secondReview:
        return 'You are in the second review cycle. You’re doing great!';
      case CycleStudied.thirdReview:
        return 'You are in the third review cycle. You almost have this mastered!';
      case CycleStudied.moreThanThreeReviews:
        return 'You’ve completed more than 3 review cycles. The knowledge is well reinforced!';
    }
  }

  // Helper function for min value
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
