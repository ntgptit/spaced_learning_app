import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';

/// Implementation of the ModuleRepository interface
class ModuleRepositoryImpl implements ModuleRepository {
  final ApiClient _apiClient;

  ModuleRepositoryImpl(this._apiClient);

  @override
  Future<List<ModuleSummary>> getAllModules({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.modules,
        queryParameters: {'page': page, 'size': size},
      );

      if (response['success'] == true && response['content'] != null) {
        final List<dynamic> moduleList = response['content'];
        return moduleList.map((item) => ModuleSummary.fromJson(item)).toList();
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
  Future<ModuleDetail> getModuleById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.modules}/$id');

      if (response['success'] == true && response['data'] != null) {
        return ModuleDetail.fromJson(response['data']);
      } else {
        throw NotFoundException('Module not found: ${response['message']}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get module: $e');
    }
  }

  @override
  Future<List<ModuleSummary>> getModulesByBookId(
    String bookId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.modulesByBook(bookId),
        queryParameters: {'page': page, 'size': size},
      );

      final content = response['content'];

      if (content != null && content is List) {
        return content.map((item) => ModuleSummary.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get modules by book: $e');
    }
  }

  // @override
  // Future<List<ModuleSummary>> getAllModulesByBookId(String bookId) async {
  //   try {
  //     final response = await _apiClient.get(
  //       ApiEndpoints.allModulesByBook(bookId),
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       final List<dynamic> moduleList = response['data'];
  //       return moduleList.map((item) => ModuleSummary.fromJson(item)).toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get all modules by book: $e');
  //   }
  // }

  // @override
  // Future<int> getNextModuleNumber(String bookId) async {
  //   try {
  //     final response = await _apiClient.get(
  //       ApiEndpoints.nextModuleNumber(bookId),
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return response['data'] as int;
  //     } else {
  //       throw BadRequestException(
  //         'Failed to get next module number: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to get next module number: $e');
  //   }
  // }

  // @override
  // Future<ModuleDetail> createModule({
  //   required String bookId,
  //   required int moduleNo,
  //   required String title,
  //   int? wordCount,
  // }) async {
  //   try {
  //     final data = <String, dynamic>{
  //       'bookId': bookId,
  //       'moduleNo': moduleNo,
  //       'title': title,
  //     };

  //     if (wordCount != null) {
  //       data['wordCount'] = wordCount;
  //     }

  //     final response = await _apiClient.post(ApiEndpoints.modules, data: data);

  //     if (response['success'] == true && response['data'] != null) {
  //       return ModuleDetail.fromJson(response['data']);
  //     } else {
  //       throw BadRequestException(
  //         'Failed to create module: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to create module: $e');
  //   }
  // }

  // @override
  // Future<ModuleDetail> updateModule(
  //   String id, {
  //   int? moduleNo,
  //   String? title,
  //   int? wordCount,
  // }) async {
  //   try {
  //     final data = <String, dynamic>{};

  //     if (moduleNo != null) {
  //       data['moduleNo'] = moduleNo;
  //     }

  //     if (title != null) {
  //       data['title'] = title;
  //     }

  //     if (wordCount != null) {
  //       data['wordCount'] = wordCount;
  //     }

  //     final response = await _apiClient.put(
  //       '${ApiEndpoints.modules}/$id',
  //       data: data,
  //     );

  //     if (response['success'] == true && response['data'] != null) {
  //       return ModuleDetail.fromJson(response['data']);
  //     } else {
  //       throw BadRequestException(
  //         'Failed to update module: ${response['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to update module: $e');
  //   }
  // }

  // @override
  // Future<void> deleteModule(String id) async {
  //   try {
  //     final response = await _apiClient.delete('${ApiEndpoints.modules}/$id');

  //     if (response == null || response['success'] != true) {
  //       throw BadRequestException(
  //         'Failed to delete module: ${response?['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     if (e is AppException) {
  //       rethrow;
  //     }
  //     throw UnexpectedException('Failed to delete module: $e');
  //   }
  // }
}
