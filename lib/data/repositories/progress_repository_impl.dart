import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

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

      if (response['success'] != true || response['content'] == null) {
        return [];
      }

      final List<dynamic> progressList = response['content'];
      return progressList
          .map((item) => ProgressSummary.fromJson(item))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to get progress records: $e');
    }
  }

  @override
  Future<ProgressDetail> getProgressById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.progress}/$id');

      if (response['success'] != true || response['data'] == null) {
        throw NotFoundException('Progress not found: ${response['message']}');
      }

      return ProgressDetail.fromJson(response['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to get progress: $e');
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

      if (response['success'] != true || response['content'] == null) {
        return [];
      }

      final List<dynamic> progressList = response['content'];
      return progressList
          .map((item) => ProgressSummary.fromJson(item))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to get progress by module: $e');
    }
  }

  @override
  Future<ProgressDetail?> getCurrentUserProgressByModule(
    String moduleId,
  ) async {
    try {
      final progressList = await getProgressByModuleId(moduleId, size: 1);

      if (progressList.isEmpty) {
        return null;
      }

      return await getProgressById(progressList[0].id);
    } on NotFoundException {
      return null;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to get module progress: $e');
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

      debugPrint(
        '[ProgressRepositoryImpl] Raw API response for getDueProgress: $response',
      );

      if (response is! Map<String, dynamic> || response['content'] is! List) {
        debugPrint(
          '[ProgressRepositoryImpl] Response is not a valid Map or does not contain a "content" list.',
        );
        debugPrint(
          '[ProgressRepositoryImpl] Response type: ${response?.runtimeType}',
        );
        return [];
      }

      final List<dynamic> progressList = response['content'];
      debugPrint(
        '[ProgressRepositoryImpl] Found ${progressList.length} due progress items before parsing.',
      );

      try {
        final parsedList = progressList
            .map((item) {
              if (item is! Map<String, dynamic>) {
                debugPrint(
                  '[ProgressRepositoryImpl] Invalid item format found in content list: $item',
                );
                return null;
              }
              return ProgressSummary.fromJson(item);
            })
            .whereType<ProgressSummary>()
            .toList();

        debugPrint(
          '[ProgressRepositoryImpl] Parsed ${parsedList.length} due progress items successfully.',
        );
        return parsedList;
      } catch (e) {
        debugPrint(
          '[ProgressRepositoryImpl] Error parsing ProgressSummary: $e',
        );
        throw DataFormatException('Failed to parse progress data: $e');
      }
    } on AppException catch (e) {
      debugPrint('[ProgressRepositoryImpl] AppException in getDueProgress: $e');
      rethrow;
    } catch (e) {
      debugPrint(
        '[ProgressRepositoryImpl] Unexpected error in getDueProgress: $e',
      );
      throw UnexpectedException('Failed to get due progress: $e');
    }
  }

  @override
  Future<ProgressDetail> createProgress({
    required String moduleId,
    String? userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    try {
      final data = <String, dynamic>{'moduleId': moduleId};

      if (userId != null) {
        data['userId'] = userId;
      }

      if (firstLearningDate != null) {
        data['firstLearningDate'] = _formatDate(firstLearningDate);
      }

      if (cyclesStudied != null) {
        data['cyclesStudied'] = cyclesStudied
            .toString()
            .split('.')
            .last
            .toUpperCase();
      }

      if (nextStudyDate != null) {
        data['nextStudyDate'] = _formatDate(nextStudyDate);
      }

      if (percentComplete != null) {
        data['percentComplete'] = percentComplete;
      }

      final response = await _apiClient.post(ApiEndpoints.progress, data: data);

      if (response['success'] != true || response['data'] == null) {
        throw BadRequestException(
          'Failed to create progress: ${response['message']}',
        );
      }

      return ProgressDetail.fromJson(response['data']);
    } on AppException {
      rethrow;
    } catch (e) {
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
        data['cyclesStudied'] = cyclesStudied
            .toString()
            .split('.')
            .last
            .toUpperCase();
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

      if (response['success'] != true || response['data'] == null) {
        throw BadRequestException(
          'Failed to update progress: ${response['message']}',
        );
      }

      return ProgressDetail.fromJson(response['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to update progress: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
