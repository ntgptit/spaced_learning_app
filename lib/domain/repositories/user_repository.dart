import 'package:spaced_learning_app/domain/models/user.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Get current authenticated user
  Future<User> getCurrentUser();

  /// Get user by ID
  // Future<User> getUserById(String id);

  /// Update user data
  Future<User> updateUser(String id, {String? displayName, String? password});

  /// Check if email exists
  Future<bool> checkEmailExists(String email);
}
