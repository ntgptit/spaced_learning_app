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

  Future<void> loadRepetitionsByProgressId(String progressId) async {
    if (_isLoading) return;

    _isLoading = true;
    beginLoading();
    notifyListeners(); // Notify loading started
    clearError();

    try {
      debugPrint('Loading repetitions for progressId: $progressId');
      _repetitions = await repetitionRepository.getRepetitionsByProgressId(
        progressId,
      );
      debugPrint('Loaded ${_repetitions.length} repetitions');
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
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Creating default schedule for progressId: $moduleProgressId');
      final schedule = await repetitionRepository.createDefaultSchedule(
        moduleProgressId,
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
    beginLoading();
    notifyListeners();
    clearError();

    try {
      debugPrint('Updating repetition: $id');
      debugPrint(
        'Status: $status, ReviewDate: $reviewDate, RescheduleFollowing: $rescheduleFollowing',
      );

      final repetition = await repetitionRepository.updateRepetition(
        id,
        status: status,
        reviewDate: reviewDate,
        rescheduleFollowing: rescheduleFollowing,
        percentComplete: percentComplete,
      );

      if (_selectedRepetition?.id == id) {
        _selectedRepetition = repetition;
      }

      // Update the list if this repetition is in it
      final index = _repetitions.indexWhere((r) => r.id == id);
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
    try {
      debugPrint('Checking completion status for progressId: $progressId');

      // If we already have loaded repetitions for this progress, use them
      List<Repetition> repetitionsToCheck;

      // Otherwise, load them from repository
      if (_repetitions.isEmpty ||
          _repetitions.first.moduleProgressId != progressId) {
        repetitionsToCheck = await repetitionRepository
            .getRepetitionsByProgressId(progressId);
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
        return 'Bạn đang trong chu kỳ đầu tiên. Hoàn thành 5 lần ôn tập để chuyển sang chu kỳ tiếp theo.';
      case CycleStudied.firstReview:
        return 'Bạn đang trong chu kỳ ôn tập đầu tiên. Hoàn thành cả 5 lần ôn tập để tiếp tục.';
      case CycleStudied.secondReview:
        return 'Bạn đang trong chu kỳ ôn tập thứ hai. Bạn đã làm rất tốt!';
      case CycleStudied.thirdReview:
        return 'Bạn đang trong chu kỳ ôn tập thứ ba. Bạn gần như đã thuộc bài học này!';
      case CycleStudied.moreThanThreeReviews:
        return 'Bạn đã hoàn thành hơn 3 chu kỳ học. Kiến thức đã được củng cố rất tốt!';
    }
  }
}
