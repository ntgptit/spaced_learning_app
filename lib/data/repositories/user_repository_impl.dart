import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/domain/repositories/user_repository.dart';

/// Implementation of the UserRepository interface
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.currentUser);

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw AuthenticationException(
          'Failed to get current user: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get current user: $e');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.users}/$id');

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw NotFoundException('User not found: ${response['message']}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to get user: $e');
    }
  }

  @override
  Future<User> updateUser(
    String id, {
    String? displayName,
    String? password,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (displayName != null) {
        data['displayName'] = displayName;
      }

      if (password != null) {
        data['password'] = password;
      }

      final response = await _apiClient.put(
        '${ApiEndpoints.users}/$id',
        data: data,
      );

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw BadRequestException(
          'Failed to update user: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw UnexpectedException('Failed to update user: $e');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      // This is a simplified implementation. In a real app, you would have a specific endpoint
      // to check if an email exists, but here we'll simulate it.

      // Note: In a real app, you would implement this endpoint or use a different approach
      return false;
    } catch (e) {
      return false;
    }
  }
}
