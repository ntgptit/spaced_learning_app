import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

/// Implementation of the ProgressRepository interface
class ProgressRepositoryImpl implements ProgressRepository {
  final ApiClient _apiClient;

  ProgressRepositoryImpl(this._apiClient);

  @override
  Future<List<ProgressSummary>> getAllProgress({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.progress,
        queryParameters: {'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> progressList = response['content'];
        return progressList
            .map((item) => ProgressSummary.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get progress records: $e');
    }
  }

  @override
  Future<ProgressDetail> getProgressById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.progress}/$id');

      if (response['success'] == true && response['data'] != null) {
        return ProgressDetail.fromJson(response['data']);
      } else {
        throw NotFoundException('Progress not found: ${response['message']}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get progress: $e');
    }
  }

  @override
  Future<List<ProgressSummary>> getProgressByUserId(
    String userId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.progressByUser(userId),
        queryParameters: {'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> progressList = response['content'];
        return progressList
            .map((item) => ProgressSummary.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get progress by user: $e');
    }
  }

  @override
  Future<List<ProgressSummary>> getProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.progress}/module/$moduleId',
        queryParameters: {'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> progressList = response['content'];
        return progressList
            .map((item) => ProgressSummary.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get progress by module: $e');
    }
  }

  @override
  Future<List<ProgressSummary>> getProgressByUserAndBook(
    String userId,
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.progressByUserAndBook(userId, bookId),
        queryParameters: {'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> progressList = response['content'];
        return progressList
            .map((item) => ProgressSummary.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get progress by user and book: $e');
    }
  }

  @override
  Future<ProgressDetail> getProgressByUserAndModule(
    String userId,
    String moduleId,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.progressByUserAndModule(userId, moduleId),
      );

      if (response['success'] == true && response['data'] != null) {
        return ProgressDetail.fromJson(response['data']);
      } else {
        throw NotFoundException('Progress not found: ${response['message']}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to get progress by user and module: $e',
      );
    }
  }

  @override
  Future<ProgressDetail?> getCurrentUserProgressByModule(
    String moduleId,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.currentUserProgressByModule(moduleId),
      );

      if (response['success'] == true) {
        if (response['data'] == null) {
          // No progress found, but API call was successful
          return null;
        }
        return ProgressDetail.fromJson(response['data']);
      } else {
        return null;
      }
    } on NotFoundException {
      // If not found, return null (this is expected)
      return null;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to get current user progress: $e');
    }
  }

  @override
  Future<List<ProgressSummary>> getDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'size': size};

      if (studyDate != null) {
        queryParams['studyDate'] = _formatDate(studyDate);
      }

      final response = await _apiClient.get(
        ApiEndpoints.dueProgress(userId),
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> progressList = response['content'];
        return progressList
            .map((item) => ProgressSummary.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get due progress: $e');
    }
  }

  @override
  Future<ProgressDetail> createProgress({
    required String moduleId,
    required String userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    try {
      final data = <String, dynamic>{'moduleId': moduleId, 'userId': userId};

      if (firstLearningDate != null) {
        data['firstLearningDate'] = _formatDate(firstLearningDate);
      }

      if (cyclesStudied != null) {
        data['cyclesStudied'] =
            cyclesStudied.toString().split('.').last.toUpperCase();
      }

      if (nextStudyDate != null) {
        data['nextStudyDate'] = _formatDate(nextStudyDate);
      }

      if (percentComplete != null) {
        data['percentComplete'] = percentComplete;
      }

      final response = await _apiClient.post(ApiEndpoints.progress, data: data);

      if (response['success'] == true && response['data'] != null) {
        return ProgressDetail.fromJson(response['data']);
      } else {
        throw BadRequestException(
          'Failed to create progress: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to create progress: $e');
    }
  }

  @override
  Future<ProgressDetail> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (firstLearningDate != null) {
        data['firstLearningDate'] = _formatDate(firstLearningDate);
      }

      if (cyclesStudied != null) {
        data['cyclesStudied'] =
            cyclesStudied.toString().split('.').last.toUpperCase();
      }

      if (nextStudyDate != null) {
        data['nextStudyDate'] = _formatDate(nextStudyDate);
      }

      if (percentComplete != null) {
        data['percentComplete'] = percentComplete;
      }

      final response = await _apiClient.put(
        '${ApiEndpoints.progress}/$id',
        data: data,
      );

      if (response['success'] == true && response['data'] != null) {
        return ProgressDetail.fromJson(response['data']);
      } else {
        throw BadRequestException(
          'Failed to update progress: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to update progress: $e');
    }
  }

  @override
  Future<void> deleteProgress(String id) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.progress}/$id');

      if (response == null || response['success'] != true) {
        throw BadRequestException(
          'Failed to delete progress: ${response?['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to delete progress: $e');
    }
  }

  /// Format date to ISO8601 string (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
