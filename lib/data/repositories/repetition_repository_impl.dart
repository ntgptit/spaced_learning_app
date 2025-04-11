import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';

/// Implementation of the RepetitionRepository interface
class RepetitionRepositoryImpl implements RepetitionRepository {
  final ApiClient _apiClient;

  RepetitionRepositoryImpl(this._apiClient);

  // @override
  // Future<List<Repetition>> getAllRepetitions({
  //   int page = 0,
  //   int size = 20,
  // }) async {
  //   try {
  //     final response = await _apiClient.get(
  //       ApiEndpoints.repetitions,
  //       queryParameters: {'page': page, 'size': size},
  //     );

  //     if (response['success'] == true && response['content'] != null) {
  //       final List<dynamic> repetitionList = response['content'];
  //       return repetitionList.map((item) => Repetition.fromJson(item)).toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get repetitions: $e');
  //   }
  // }

  // @override
  // Future<Repetition> getRepetitionById(String id) async {
  //   try {
  //     final response = await _apiClient.get('${ApiEndpoints.repetitions}/$id');

  //     if (response['success'] == true && response['data'] != null) {
  //       return Repetition.fromJson(response['data']);
  //     } else {
  //       throw NotFoundException('Repetition not found: ${response['message']}');
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get repetition: $e');
  //   }
  // }

  @override
  Future<List<Repetition>> getRepetitionsByProgressId(String progressId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.repetitionsByProgress(progressId),
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> repetitionList = response['data'];
        return repetitionList.map((item) => Repetition.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get repetitions by progress: $e');
    }
  }

  // @override
  // Future<Repetition> getRepetitionByProgressIdAndOrder(
  //   String progressId,
  //   RepetitionOrder order,
  // ) async {
  //   try {
  //     final orderStr = order.toString().split('.').last.toUpperCase();
  //     final response = await _apiClient.get(
  //       ApiEndpoints.repetitionByOrder(progressId, orderStr),
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return Repetition.fromJson(response['data']);
  //     } else {
  //       throw NotFoundException('Repetition not found: ${response['message']}');
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get repetition by order: $e');
  //   }
  // }

  // @override
  // Future<List<Repetition>> getDueRepetitions(
  //   String userId, {
  //   DateTime? reviewDate,
  //   RepetitionStatus? status,
  //   int page = 0,
  //   int size = 20,
  // }) async {
  //   try {
  //     final Map<String, dynamic> queryParams = {'page': page, 'size': size};

  //     if (reviewDate != null) {
  //       queryParams['reviewDate'] = _formatDate(reviewDate);
  //     }

  //     if (status != null) {
  //       queryParams['status'] = status.toString().split('.').last.toUpperCase();
  //     }

  //     final response = await _apiClient.get(
  //       ApiEndpoints.dueRepetitions(userId),
  //       queryParameters: queryParams,
  //     );

  //     if (response['success'] == true && response['content'] != null) {
  //       final List<dynamic> repetitionList = response['content'];
  //       return repetitionList.map((item) => Repetition.fromJson(item)).toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get due repetitions: $e');
  //   }
  // }

  // @override
  // Future<Repetition> createRepetition({
  //   required String moduleProgressId,
  //   required RepetitionOrder repetitionOrder,
  //   RepetitionStatus? status,
  //   DateTime? reviewDate,
  // }) async {
  //   try {
  //     final data = <String, dynamic>{
  //       'moduleProgressId': moduleProgressId,
  //       'repetitionOrder':
  //           repetitionOrder.toString().split('.').last.toUpperCase(),
  //     };

  //     if (status != null) {
  //       data['status'] = status.toString().split('.').last.toUpperCase();
  //     }

  //     if (reviewDate != null) {
  //       data['reviewDate'] = _formatDate(reviewDate);
  //     }

  //     final response = await _apiClient.post(
  //       ApiEndpoints.repetitions,
  //       data: data,
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return Repetition.fromJson(response['data']);
  //     } else {
  //       throw BadRequestException(
  //         'Failed to create repetition: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to create repetition: $e');
  //   }
  // }

  @override
  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.repetitionSchedule(moduleProgressId),
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> repetitionList = response['data'];
        return repetitionList.map((item) => Repetition.fromJson(item)).toList();
      } else {
        throw BadRequestException(
          'Failed to create repetition schedule: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to create repetition schedule: $e');
    }
  }

  @override
  Future<Repetition> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (status != null) {
        data['status'] = status.toString().split('.').last.toUpperCase();
      }

      if (reviewDate != null) {
        data['reviewDate'] = _formatDate(reviewDate);
      }

      data['rescheduleFollowing'] = rescheduleFollowing;

      final response = await _apiClient.put(
        '${ApiEndpoints.repetitions}/$id',
        data: data,
      );

      if (response['success'] == true && response['data'] != null) {
        return Repetition.fromJson(response['data']);
      } else {
        throw BadRequestException(
          'Failed to update repetition: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to update repetition: $e');
    }
  }

  // @override
  // Future<void> deleteRepetition(String id) async {
  //   try {
  //     final response = await _apiClient.delete(
  //       '${ApiEndpoints.repetitions}/$id',
  //     );

  //     if (response == null || response['success'] != true) {
  //       throw BadRequestException(
  //         'Failed to delete repetition: ${response?['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to delete repetition: $e');
  //   }
  // }

  @override
  Future<int> countByModuleProgressId(String moduleProgressId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.repetitions}/count',
        queryParameters: {'moduleProgressId': moduleProgressId},
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as int;
      } else {
        return 0;
      }
    } catch (e) {
      // Fallback: Count from available repetitions
      final repetitions = await getRepetitionsByProgressId(moduleProgressId);
      return repetitions.length;
    }
  }

  /// Format date to ISO8601 string (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
