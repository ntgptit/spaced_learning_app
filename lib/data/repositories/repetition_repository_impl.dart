import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';

class RepetitionRepositoryImpl implements RepetitionRepository {
  final ApiClient _apiClient;

  RepetitionRepositoryImpl(this._apiClient);





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
      final repetitions = await getRepetitionsByProgressId(moduleProgressId);
      return repetitions.length;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
