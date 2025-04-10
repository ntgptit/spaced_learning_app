import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class RepetitionViewModel extends BaseViewModel {
  final RepetitionRepository repetitionRepository;
  List<Repetition> _repetitions = [];
  Repetition? _selectedRepetition;

  RepetitionViewModel({required this.repetitionRepository});

  List<Repetition> get repetitions => _repetitions;
  Repetition? get selectedRepetition => _selectedRepetition;



  Future<void> loadRepetitionsByProgressId(String progressId) async {
    await safeCall(
      action: () async {
        _repetitions = await repetitionRepository.getRepetitionsByProgressId(
          progressId,
        );
        return _repetitions;
      },
      errorPrefix: 'Failed to load repetitions by progress',
    );
  }




  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    final result = await safeCall<List<Repetition>>(
      action:
          () => repetitionRepository.createDefaultSchedule(moduleProgressId),
      errorPrefix: 'Failed to create repetition schedule',
    );
    return result ?? [];
  }

  Future<Repetition?> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
  }) async {
    return safeCall<Repetition>(
      action: () async {
        final repetition = await repetitionRepository.updateRepetition(
          id,
          status: status,
          reviewDate: reviewDate,
          rescheduleFollowing: rescheduleFollowing,
        );

        if (_selectedRepetition?.id == id) {
          _selectedRepetition = repetition;
        }

        final index = _repetitions.indexWhere((r) => r.id == id);
        if (index >= 0) {
          _repetitions[index] = repetition;
        }

        if (rescheduleFollowing) {
          await loadRepetitionsByProgressId(repetition.moduleProgressId);
        }

        return repetition;
      },
      errorPrefix: 'Failed to update repetition',
    );
  }




  Future<bool> areAllRepetitionsCompleted(String progressId) async {
    try {
      final repetitions = await repetitionRepository.getRepetitionsByProgressId(
        progressId,
      );
      if (repetitions.isEmpty) return false;

      final totalCount = repetitions.length;
      final completedCount =
          repetitions
              .where((r) => r.status == RepetitionStatus.completed)
              .length;

      return completedCount >= totalCount;
    } catch (e) {
      handleError(e, prefix: 'Failed to check repetition completion status');
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
