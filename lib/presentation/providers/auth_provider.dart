// lib/presentation/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/di/providers.dart';
import 'package:spaced_learning_app/domain/models/auth_response.dart';
import 'package:spaced_learning_app/domain/models/user.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    final storageService = ref.watch(storageServiceProvider);

    // Check if there's a token stored
    final token = await storageService.getToken();
    if (token == null) return null;

    // Validate token with backend
    final authRepository = ref.read(authRepositoryProvider);
    final isValid = await authRepository.validateToken(token);

    if (!isValid) {
      // Try refresh token flow
      try {
        final refreshToken = await storageService.getRefreshToken();
        if (refreshToken != null) {
          final response = await authRepository.refreshToken(refreshToken);
          await _saveAuthData(response);
          return response.user;
        }
      } catch (e) {
        // Refresh token failed, logging out
        await logout();
        return null;
      }
      return null;
    }

    // If token valid, get user data from storage
    final userData = await storageService.getUserData();
    if (userData == null) return null;

    return User.fromJson(userData);
  }

  Future<User> login(String usernameOrEmail, String password) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.login(usernameOrEmail, password);

      await _saveAuthData(response);

      state = AsyncValue.data(response.user);
      return response.user;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<User> register(
    String username,
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.register(
        username,
        email,
        password,
        firstName,
        lastName,
      );

      await _saveAuthData(response);

      state = AsyncValue.data(response.user);
      return response.user;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.clearTokens();
      await storageService.clearUserData();

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> _saveAuthData(AuthResponse response) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveToken(response.token);
    if (response.refreshToken != null) {
      await storageService.saveRefreshToken(response.refreshToken!);
    }
    await storageService.saveUserData(response.user.toJson());
  }
}

@riverpod
Future<bool> authState(AuthStateRef ref) async {
  final user = await ref.watch(authProvider.future);
  return user != null;
}
