import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// View model for module progress operations
class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository progressRepository;
  final ReminderManager? reminderManager; // Thêm ReminderManager

  bool _isLoading = false;
  List<ProgressSummary> _progressRecords = [];
  ProgressDetail? _selectedProgress;
  String? _errorMessage;

  ProgressViewModel({
    required this.progressRepository,
    this.reminderManager, // Optional để tránh lỗi trong unit tests
  });

  // Getters
  bool get isLoading => _isLoading;
  List<ProgressSummary> get progressRecords => _progressRecords;
  ProgressDetail? get selectedProgress => _selectedProgress;
  String? get errorMessage => _errorMessage;

  /// Load all progress records with pagination
  Future<void> loadProgressRecords({int page = 0, int size = 20}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getAllProgress(
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

  /// Load progress details by ID
  Future<void> loadProgressDetails(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedProgress = await progressRepository.getProgressById(id);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records by user ID
  Future<void> loadProgressByUserId(
    String userId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByUserId(
        userId,
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

  /// Load progress records by module ID
  Future<void> loadProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByModuleId(
        moduleId,
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

  /// Load progress records by user ID and book ID
  Future<void> loadProgressByUserAndBook(
    String userId,
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _progressRecords = await progressRepository.getProgressByUserAndBook(
        userId,
        bookId,
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

  /// Load progress by user ID and module ID
  Future<ProgressDetail?> loadProgressByUserAndModule(
    String userId,
    String moduleId,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.getProgressByUserAndModule(
        userId,
        moduleId,
      );
      _selectedProgress = progress;
      return progress;
    } on NotFoundException {
      // If not found, return null but don't set error (this is expected)
      _selectedProgress = null;
      return null;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _selectedProgress = null;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _selectedProgress = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress for current user and a specific module
  Future<ProgressDetail?> loadCurrentUserProgressByModule(
    String moduleId,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.getCurrentUserProgressByModule(
        moduleId,
      );
      _selectedProgress = progress;
      return progress;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _selectedProgress = null;
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _selectedProgress = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load progress records due for study
  Future<void> loadDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    // DEBUG: Log bắt đầu load
    debugPrint(
      '[ProgressViewModel] Starting loadDueProgress for userId: $userId, date: $studyDate',
    );

    try {
      // Lấy dữ liệu từ repository
      final List<ProgressSummary> result = await progressRepository
          .getDueProgress(userId, studyDate: studyDate, page: page, size: size);
      // DEBUG: Log kết quả từ repository
      debugPrint(
        '[ProgressViewModel] Received ${result.length} records from repository for due progress.',
      );

      // Gán dữ liệu vào state
      _progressRecords = result;

      // Cập nhật nhắc nhở sau khi load dữ liệu
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

      // DEBUG: Log sau khi gán state
      debugPrint(
        '[ProgressViewModel] Assigned ${result.length} records to _progressRecords.',
      );
    } on AppException catch (e) {
      _errorMessage = e.message;
      _progressRecords = []; // Xóa dữ liệu cũ nếu có lỗi
      // DEBUG: Log lỗi AppException
      debugPrint(
        '[ProgressViewModel] AppException during loadDueProgress: $_errorMessage',
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _progressRecords = []; // Xóa dữ liệu cũ nếu có lỗi
      // DEBUG: Log lỗi khác
      debugPrint(
        '[ProgressViewModel] Unexpected error during loadDueProgress: $e',
      );
    } finally {
      _setLoading(false);
      // DEBUG: Log kết thúc load (thành công hoặc thất bại)
      debugPrint(
        '[ProgressViewModel] Finished loadDueProgress. isLoading: $_isLoading, error: $_errorMessage, record count: ${_progressRecords.length}',
      );
    }
  }

  /// Create a new progress record
  Future<ProgressDetail?> createProgress({
    required String moduleId,
    required String userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final progress = await progressRepository.createProgress(
        moduleId: moduleId,
        userId: userId,
        firstLearningDate: firstLearningDate,
        cyclesStudied: cyclesStudied,
        nextStudyDate: nextStudyDate,
        percentComplete: percentComplete,
      );

      // Cập nhật nhắc nhở sau khi tạo tiến độ mới
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

      return progress;
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

  /// Update a progress record
  Future<ProgressDetail?> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
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

      // Cập nhật nhắc nhở sau khi hoàn thành nhiệm vụ
      if (reminderManager != null) {
        await reminderManager!.updateRemindersAfterTaskCompletion();
      }

      return progress;
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

  /// Delete a progress record
  Future<bool> deleteProgress(String id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await progressRepository.deleteProgress(id);

      if (_selectedProgress?.id == id) {
        _selectedProgress = null;
      }

      _progressRecords =
          _progressRecords.where((progress) => progress.id != id).toList();

      // Cập nhật nhắc nhở sau khi xóa tiến độ
      if (reminderManager != null) {
        await reminderManager!.scheduleAllReminders();
      }

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

  /// Refresh progress details
  Future<void> refreshProgressDetails(String progressId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedProgress = await progressRepository.getProgressById(progressId);
    } catch (e) {
      // Just log the error, don't set error message to avoid UI disruption
      debugPrint('Error refreshing progress details: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get the count of due progress records
  Future<int> getDueTodayCount() async {
    try {
      return _progressRecords.length;
    } catch (e) {
      debugPrint('Error getting due progress count: $e');
      return 0;
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    // DEBUG: Log thay đổi trạng thái loading
    debugPrint('[ProgressViewModel] Setting isLoading to: $loading');
    if (_isLoading != loading) {
      // Chỉ cập nhật và thông báo nếu trạng thái thực sự thay đổi
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
