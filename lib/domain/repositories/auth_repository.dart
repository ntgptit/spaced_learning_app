import 'package:spaced_learning_app/domain/models/auth_response.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Authenticate user with username/email and password
  Future<AuthResponse> login(String usernameOrEmail, String password);

  /// Register a new user
  Future<AuthResponse> register(
    String username,
    String email,
    String password,
    String firstName,
    String lastName,
  );

  /// Refresh the authentication token
  Future<AuthResponse> refreshToken(String refreshToken);

  /// Validate authentication token
  Future<bool> validateToken(String token);

  /// Get username from token
  String? getUsernameFromToken(String token);
}
