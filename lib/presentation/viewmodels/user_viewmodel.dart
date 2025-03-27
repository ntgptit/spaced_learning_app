import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/domain/repositories/user_repository.dart';

/// View model for user operations
class UserViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  bool _isLoading = false;
  User? _currentUser;
  String? _errorMessage;

  UserViewModel({required this.userRepository});

  // Getters
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  /// Load current user information
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await userRepository.getCurrentUser();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<bool> updateProfile({String? displayName, String? password}) async {
    if (_currentUser == null) {
      _errorMessage = 'User is not loaded';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await userRepository.updateUser(
        _currentUser!.id,
        displayName: displayName,
        password: password,
      );
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

  /// Check if an email is already registered
  Future<bool> isEmailAvailable(String email) async {
    try {
      final exists = await userRepository.checkEmailExists(email);
      return !exists;
    } catch (e) {
      return false;
    }
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
