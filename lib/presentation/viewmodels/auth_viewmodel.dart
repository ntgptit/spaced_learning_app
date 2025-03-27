import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/domain/models/auth_response.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/domain/repositories/auth_repository.dart';

/// View model for authentication
class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final StorageService storageService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _errorMessage;

  AuthViewModel({required this.authRepository, required this.storageService}) {
    _checkAuthentication();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  /// Check if the user is already authenticated
  Future<void> _checkAuthentication() async {
    final token = await storageService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
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
      } catch (e) {
        _isAuthenticated = false;
        await storageService.clearTokens();
      }
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await authRepository.login(email, password);
      await _handleAuthResponse(response);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register a new user
  Future<bool> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await authRepository.register(
        email,
        password,
        firstName,
        lastName,
      );
      await _handleAuthResponse(response);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await storageService.clearTokens();
      await storageService.clearUserData();
      _isAuthenticated = false;
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'An error occurred while logging out';
    } finally {
      _setLoading(false);
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
    _errorMessage = null;
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
