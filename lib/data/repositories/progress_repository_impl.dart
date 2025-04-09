import 'package:flutter/foundation.dart';
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
      // Mặc dù API đã thay đổi, vẫn giữ lại signature để đảm bảo tương thích
      // Bây giờ gọi API để lấy tất cả progress của module
      final progressList = await getProgressByModuleId(moduleId, size: 1);

      if (progressList.isNotEmpty) {
        // Lấy chi tiết của progress đầu tiên
        return await getProgressById(progressList[0].id);
      }
      return null;
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

      // DEBUG: In ra response thô từ API
      debugPrint(
        '[ProgressRepositoryImpl] Raw API response for getDueProgress: $response',
      );

      // --- SỬA ĐỔI TỪ ĐÂY ---
      // Kiểm tra xem response có phải là Map và có chứa key 'content' là List không
      if (response is Map<String, dynamic> && response['content'] is List) {
        final List<dynamic> progressList = response['content'];
        // DEBUG: In ra số lượng item trước khi parse
        debugPrint(
          '[ProgressRepositoryImpl] Found ${progressList.length} due progress items before parsing.',
        );
        try {
          // Đảm bảo parse an toàn hơn
          final parsedList =
              progressList
                  .map((item) {
                    if (item is Map<String, dynamic>) {
                      return ProgressSummary.fromJson(item);
                    } else {
                      // Log item không hợp lệ nếu cần
                      debugPrint(
                        '[ProgressRepositoryImpl] Invalid item format found in content list: $item',
                      );
                      return null; // Hoặc throw lỗi tùy logic xử lý
                    }
                  })
                  .whereType<
                    ProgressSummary
                  >() // Chỉ giữ lại những item parse thành công và không null
                  .toList();
          // DEBUG: In ra số lượng item sau khi parse
          debugPrint(
            '[ProgressRepositoryImpl] Parsed ${parsedList.length} due progress items successfully.',
          );
          return parsedList;
        } catch (e) {
          // DEBUG: In ra lỗi parsing
          debugPrint(
            '[ProgressRepositoryImpl] Error parsing ProgressSummary: $e',
          );
          // Có thể in ra toàn bộ list để dễ debug hơn
          // debugPrint('[ProgressRepositoryImpl] Failed content data: $progressList');
          throw DataFormatException('Failed to parse progress data: $e');
        }
      } else {
        // DEBUG: In ra lý do không có content hoặc sai định dạng
        debugPrint(
          '[ProgressRepositoryImpl] Response is not a valid Map or does not contain a "content" list.',
        );
        debugPrint(
          '[ProgressRepositoryImpl] Response type: ${response?.runtimeType}',
        );
        return [];
      }
      // --- KẾT THÚC SỬA ĐỔI ---
    } on AppException catch (e) {
      // DEBUG: In ra AppException
      debugPrint('[ProgressRepositoryImpl] AppException in getDueProgress: $e');
      rethrow;
    } catch (e) {
      // DEBUG: In ra lỗi không mong muốn khác
      debugPrint(
        '[ProgressRepositoryImpl] Unexpected error in getDueProgress: $e',
      );
      throw UnexpectedException('Failed to get due progress: $e');
    }
  }

  @override
  Future<ProgressDetail> createProgress({
    required String moduleId,
    String? userId, // Changed to optional
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    try {
      final data = <String, dynamic>{'moduleId': moduleId};

      // Only add userId if provided
      if (userId != null) {
        data['userId'] = userId;
      }

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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
