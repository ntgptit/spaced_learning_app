import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/domain/models/auth_response.dart';
import 'package:spaced_learning_app/domain/repositories/auth_repository.dart';

/// Implementation of the AuthRepository interface
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final data = {'email': email, 'password': password};

      // Debug trước khi gọi API
      debugPrint('Calling login API with email: $email');

      final response = await _apiClient.post(ApiEndpoints.login, data: data);

      // Log để debug
      debugPrint('Full login response: $response');

      if (response == null) {
        throw AuthenticationException('Login failed: No response received');
      }

      if (response['success'] != true) {
        throw AuthenticationException(
          'Login failed: ${response['message'] ?? "Unknown error"}',
        );
      }

      if (response['data'] == null || response['data']['token'] == null) {
        throw AuthenticationException(
          'Login failed: Authentication token not found in response',
        );
      }
      return AuthResponse.fromJson(response['data']);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AuthenticationException('Failed to login: $e');
    }
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };

      final response = await _apiClient.post(ApiEndpoints.register, data: data);

      if (response['success'] == true && response['data'] != null) {
        // For register, the API returns a user object, not an auth response
        // We need to login after successful registration
        return login(email, password);
      } else {
        throw AuthenticationException(
          'Failed to register: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AuthenticationException('Failed to register: $e');
    }
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final data = {'refreshToken': refreshToken};

      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: data,
      );

      if (response['success'] == true && response['data'] != null) {
        return AuthResponse.fromJson(response['data']);
      } else {
        throw AuthenticationException(
          'Failed to refresh token: ${response['message']}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AuthenticationException('Failed to refresh token: $e');
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.validateToken,
        queryParameters: {'token': token},
      );

      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  @override
  String? getUsernameFromToken(String token) {
    // Note: Token decoding would normally be done here, but for this app
    // we'll leave it to the server side
    return null;
  }
}
