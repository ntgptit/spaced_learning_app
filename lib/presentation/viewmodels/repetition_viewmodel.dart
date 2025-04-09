import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';

class RepetitionViewModel extends ChangeNotifier {
  final RepetitionRepository repetitionRepository;
  bool _isLoading = false;
  List<Repetition> _repetitions = [];
  Repetition? _selectedRepetition;
  String? _errorMessage;

  RepetitionViewModel({required this.repetitionRepository});

  bool get isLoading => _isLoading;
  List<Repetition> get repetitions => _repetitions;
  Repetition? get selectedRepetition => _selectedRepetition;
  String? get errorMessage => _errorMessage;

  Future<void> loadRepetitions({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _repetitions = await repetitionRepository.getAllRepetitions(
        page: page,
        size: size,
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRepetitionById(String id) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _selectedRepetition = await repetitionRepository.getRepetitionById(id);
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRepetitionsByProgressId(String progressId) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _repetitions = await repetitionRepository.getRepetitionsByProgressId(
        progressId,
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<Repetition?> loadRepetitionByProgressIdAndOrder(
    String progressId,
    RepetitionOrder order,
  ) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final repetition = await repetitionRepository
          .getRepetitionByProgressIdAndOrder(progressId, order);
      _selectedRepetition = repetition;
      return repetition;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadDueRepetitions(
    String userId, {
    DateTime? reviewDate,
    RepetitionStatus? status,
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _repetitions = await repetitionRepository.getDueRepetitions(
        userId,
        reviewDate: reviewDate,
        status: status,
        page: page,
        size: size,
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<Repetition?> createRepetition({
    required String moduleProgressId,
    required RepetitionOrder repetitionOrder,
    RepetitionStatus? status,
    DateTime? reviewDate,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final repetition = await repetitionRepository.createRepetition(
        moduleProgressId: moduleProgressId,
        repetitionOrder: repetitionOrder,
        status: status,
        reviewDate: reviewDate,
      );
      return repetition;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final schedule = await repetitionRepository.createDefaultSchedule(
        moduleProgressId,
      );
      return schedule;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return [];
    } finally {
      _setLoading(false);
    }
  }

  Future<Repetition?> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final repetition = await repetitionRepository.updateRepetition(
        id,
        status: status,
        reviewDate: reviewDate,
        rescheduleFollowing: rescheduleFollowing,
      );
      if (_selectedRepetition?.id == id) _selectedRepetition = repetition;
      final index = _repetitions.indexWhere((r) => r.id == id);
      if (index >= 0) _repetitions[index] = repetition;
      if (rescheduleFollowing)
        await loadRepetitionsByProgressId(repetition.moduleProgressId);
      return repetition;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteRepetition(String id) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await repetitionRepository.deleteRepetition(id);
      if (_selectedRepetition?.id == id) _selectedRepetition = null;
      _repetitions =
          _repetitions.where((repetition) => repetition.id != id).toList();
      return true;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
