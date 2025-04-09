// lib/presentation/viewmodels/repetition_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';

/// View model for repetition operations
class RepetitionViewModel extends ChangeNotifier {
  final RepetitionRepository repetitionRepository;

  bool _isLoading = false;
  List<Repetition> _repetitions = [];
  Repetition? _selectedRepetition;
  String? _errorMessage;

  RepetitionViewModel({required this.repetitionRepository});

  // Getters
  bool get isLoading => _isLoading;
  List<Repetition> get repetitions => _repetitions;
  Repetition? get selectedRepetition => _selectedRepetition;
  String? get errorMessage => _errorMessage;

  /// Load all repetitions with pagination
  Future<void> loadRepetitions({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _repetitions = await repetitionRepository.getAllRepetitions(
        page: page,
        size: size,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load repetition by ID
  Future<void> loadRepetitionById(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedRepetition = await repetitionRepository.getRepetitionById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load repetitions by progress ID
  Future<void> loadRepetitionsByProgressId(String progressId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _repetitions = await repetitionRepository.getRepetitionsByProgressId(
        progressId,
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load repetition by progress ID and order
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
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load repetitions due for review
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
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new repetition
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
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Create default repetition schedule for a progress record
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
    } on AppException catch (e) {
      _errorMessage = e.message;
      return [];
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return [];
    } finally {
      _setLoading(false);
    }
  }

  /// Update a repetition
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
      if (_selectedRepetition?.id == id) {
        _selectedRepetition = repetition;
      }
      final index = _repetitions.indexWhere((r) => r.id == id);
      if (index >= 0) {
        _repetitions[index] = repetition;
      }
      if (rescheduleFollowing) {
        // Tải lại toàn bộ danh sách nếu rescheduleFollowing
        await loadRepetitionsByProgressId(repetition.moduleProgressId);
      }
      return repetition;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a repetition
  Future<bool> deleteRepetition(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repetitionRepository.deleteRepetition(id);

      if (_selectedRepetition?.id == id) {
        _selectedRepetition = null;
      }

      _repetitions =
          _repetitions.where((repetition) => repetition.id != id).toList();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if all repetitions in a cycle are completed
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

  /// Get a user-friendly description of the cycle stage
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

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
