import 'package:dio/dio.dart';
import 'package:spaced_learning_app/core/constants/api_endpoints.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';

/// Interceptor to add authentication tokens to requests
class AuthInterceptor extends Interceptor {
  final StorageService _storageService = serviceLocator<StorageService>();
  final Dio _dio = Dio();
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authentication for auth endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    final token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      // Only attempt refresh if this is not already a refresh token request
      if (!_shouldSkipAuth(err.requestOptions.path)) {
        try {
          final refreshedToken = await _refreshToken();
          if (refreshedToken != null) {
            // Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $refreshedToken';

            // Create a new request with the updated token
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          // If refresh token fails, proceed with the original error
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  /// Check if authentication should be skipped for this path
  bool _shouldSkipAuth(String path) {
    final authPaths = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      ApiEndpoints.validateToken,
    ];

    return authPaths.any((authPath) => path.contains(authPath));
  }

  /// Refresh the access token using the refresh token
  Future<String?> _refreshToken() async {
    _isRefreshing = true;

    try {
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        // No refresh token available
        await _storageService.clearTokens();
        _isRefreshing = false;
        return null;
      }

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];

        if (newToken != null && newRefreshToken != null) {
          await _storageService.saveToken(newToken);
          await _storageService.saveRefreshToken(newRefreshToken);
          _isRefreshing = false;
          return newToken;
        }
      }

      // If we get here, something went wrong
      await _storageService.clearTokens();
      _isRefreshing = false;
      return null;
    } catch (e) {
      // Clear tokens on error
      await _storageService.clearTokens();
      _isRefreshing = false;
      return null;
    }
  }
}
