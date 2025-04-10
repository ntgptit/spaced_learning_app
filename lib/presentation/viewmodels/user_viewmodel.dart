// lib/presentation/viewmodels/user_viewmodel.dart
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/domain/repositories/user_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

/// View model for user operations
class UserViewModel extends BaseViewModel {
  final UserRepository userRepository;

  User? _currentUser;

  UserViewModel({required this.userRepository});

  // Getters
  User? get currentUser => _currentUser;

  /// Load current user information
  Future<void> loadCurrentUser() async {
    await safeCall(
      action: () async {
        _currentUser = await userRepository.getCurrentUser();
        return _currentUser;
      },
      errorPrefix: 'Failed to load current user',
    );
  }

  /// Update user profile
  Future<bool> updateProfile({String? displayName, String? password}) async {
    if (_currentUser == null) {
      setError('User is not loaded');
      return false;
    }

    final result = await safeCall<User>(
      action: () async {
        return userRepository.updateUser(
          _currentUser!.id,
          displayName: displayName,
          password: password,
        );
      },
      errorPrefix: 'Failed to update profile',
    );

    if (result != null) {
      _currentUser = result;
      return true;
    }
    return false;
  }

  /// Check if an email is already registered
  Future<bool> isEmailAvailable(String email) async {
    final result = await safeCall<bool>(
      action: () async {
        final exists = await userRepository.checkEmailExists(email);
        return !exists;
      },
      errorPrefix: 'Failed to check email availability',
      handleLoading: false,
    );
    return result ?? false;
  }
}
