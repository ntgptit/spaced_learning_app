// lib/presentation/viewmodels/auth_viewmodel.dart
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/domain/models/auth_response.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/domain/repositories/auth_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// View model for authentication
class AuthViewModel extends BaseViewModel {
  final AuthRepository authRepository;
  final StorageService storageService;

  bool _isAuthenticated = false;
  User? _currentUser;

  AuthViewModel({required this.authRepository, required this.storageService}) {
    _checkAuthentication();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  /// Check if the user is already authenticated
  Future<void> _checkAuthentication() async {
    beginLoading();

    try {
      final token = await storageService.getToken();
      if (token != null && token.isNotEmpty) {
        final isValid = await authRepository.validateToken(token);
        _isAuthenticated = isValid;

        if (isValid) {
          final userData = await storageService.getUserData();
          if (userData != null) {
            _currentUser = User.fromJson(userData);
          }
        } else {
          // Token is invalid, clear it
          await storageService.clearTokens();
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _isAuthenticated = false;
      await storageService.clearTokens();
      handleError(e, prefix: 'Authentication check failed');
    } finally {
      endLoading();
    }
  }

  /// Login with username/email and password
  Future<bool> login(String usernameOrEmail, String password) async {
    final result = await safeCall<bool>(
      action: () async {
        final response = await authRepository.login(usernameOrEmail, password);
        await _handleAuthResponse(response);
        return true;
      },
      errorPrefix: 'Login failed',
    );
    return result ?? false;
  }

  /// Register a new user
  Future<bool> register(
    String username,
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final result = await safeCall<bool>(
      action: () async {
        final response = await authRepository.register(
          username,
          email,
          password,
          firstName,
          lastName,
        );
        await _handleAuthResponse(response);
        return true;
      },
      errorPrefix: 'Registration failed',
    );
    return result ?? false;
  }

  /// Logout the current user
  Future<void> logout() async {
    beginLoading();

    try {
      await storageService.clearTokens();
      await storageService.clearUserData();
      _isAuthenticated = false;
      _currentUser = null;
      clearError();
    } catch (e) {
      handleError(e, prefix: 'Logout failed');
    } finally {
      endLoading();
    }
  }

  /// Save authentication data from response
  Future<void> _handleAuthResponse(AuthResponse response) async {
    await storageService.saveToken(response.token);
    if (response.refreshToken != null) {
      await storageService.saveRefreshToken(response.refreshToken!);
    }
    await storageService.saveUserData(response.user.toJson());

    _currentUser = response.user;
    _isAuthenticated = true;
    clearError();
  }
}
