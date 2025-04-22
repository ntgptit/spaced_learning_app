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

      if (response['success'] != true || response['data'] == null) {
        return [];
      }

      final List<dynamic> repetitionList = response['data'];
      return repetitionList.map((item) => Repetition.fromJson(item)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
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

      if (response['success'] != true || response['data'] == null) {
        throw BadRequestException(
          'Failed to create repetition schedule: ${response['message']}',
        );
      }

      final List<dynamic> repetitionList = response['data'];
      return repetitionList.map((item) => Repetition.fromJson(item)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Failed to create repetition schedule: $e');
    }
  }

  @override
  Future<Repetition> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
    double? percentComplete,
  }) async {
    try {
      final data = <String, dynamic>{
        'rescheduleFollowing': rescheduleFollowing,
      };

      if (status != null) {
        data['status'] = status.toString().split('.').last.toUpperCase();
      }

      if (reviewDate != null) {
        data['reviewDate'] = _formatDate(reviewDate);
      }

      if (percentComplete != null) {
        data['percentComplete'] = percentComplete;
      }

      final response = await _apiClient.put(
        '${ApiEndpoints.repetitions}/$id',
        data: data,
      );

      if (response['success'] != true || response['data'] == null) {
        throw BadRequestException(
          'Failed to update repetition: ${response['message']}',
        );
      }

      return Repetition.fromJson(response['data']);
    } on AppException {
      rethrow;
    } catch (e) {
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
      }

      // Fallback to counting the actual repetitions
      final repetitions = await getRepetitionsByProgressId(moduleProgressId);
      return repetitions.length;
    } catch (e) {
      // Fallback to counting the actual repetitions
      final repetitions = await getRepetitionsByProgressId(moduleProgressId);
      return repetitions.length;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
