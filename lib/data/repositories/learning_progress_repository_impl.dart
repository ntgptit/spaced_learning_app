// lib/data/repositories/learning_progress_repository_impl.dart
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/repositories/learning_progress_repository.dart';

/// Implementation of the LearningProgressRepository interface
class LearningProgressRepositoryImpl implements LearningProgressRepository {
  final ApiClient _apiClient;

  LearningProgressRepositoryImpl(this._apiClient);

  @override
  Future<List<LearningModule>> getAllModules() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.learningModules);

      // Kiểm tra cấu trúc response mới
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> modulesList = response['data'];

        // Chuyển đổi từ response mới sang LearningModule
        return modulesList.map((item) {
          final learningModuleResponse = LearningModule.fromJson(item);
          return learningModuleResponse;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get modules: $e');
    }
  }

  @override
  Future<List<LearningModule>> getDueModules(int daysThreshold) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.dueModules,
        queryParameters: {'daysThreshold': daysThreshold},
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> modulesList = response['data'];

        // Chuyển đổi từ response mới sang LearningModule
        return modulesList.map((item) {
          final learningModuleResponse = LearningModule.fromJson(item);
          return learningModuleResponse;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get due modules: $e');
    }
  }

  // @override
  // Future<List<LearningModule>> getCompletedModules() async {
  //   try {
  //     final response = await _apiClient.get(ApiEndpoints.completedModules);

  //     if (response['success'] == true && response['data'] != null) {
  //       final List<dynamic> modulesList = response['data'];
  //       return modulesList
  //           .map((item) => LearningModule.fromJson(item))
  //           .toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get completed modules: $e');
  //   }
  // }

  @override
  Future<List<String>> getUniqueBooks() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.uniqueBooks);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> booksList = response['data'];
        return booksList.map((item) => item.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get unique books: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportData() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.exportData);

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw BadRequestException(
          'Failed to export data: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to export data: $e');
    }
  }

  // @override
  // Future<Map<String, dynamic>> getBookStats(String bookName) async {
  //   try {
  //     final response = await _apiClient.get(
  //       ApiEndpoints.bookStats.replaceFirst('{book}', bookName),
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return response['data'] as Map<String, dynamic>;
  //     } else {
  //       throw BadRequestException(
  //         'Failed to get book stats: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get book stats: $e');
  //   }
  // }

  @override
  Future<Map<String, dynamic>> getDashboardStats({
    String? book,
    DateTime? date,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (book != null) {
        queryParams['book'] = book;
      }

      if (date != null) {
        queryParams['date'] = DateFormat('yyyy-MM-dd').format(date);
      }

      final response = await _apiClient.get(
        ApiEndpoints.dashboardStats,
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw BadRequestException(
          'Failed to get dashboard stats: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get dashboard stats: $e');
    }
  }
}
